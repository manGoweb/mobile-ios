//
//  ContentManager.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ContentManager.h"
#import "APIManager.h"
#import "LoginViewController.h"
#import "Bike.h"

NSString *const ContentManagerDidAuthenticateUserNotification = @"ContentManagerDidAuthenticateUserNotification";
NSString *const ContentManagerWillAuthenticateUserNotification = @"ContentManagerWillAuthenticateUserNotification";
NSString *const ContentManagerDidChangeUsingBikeNotification = @"ContentManagerDidChangeUsingBikeNotification";

NSString *const KeychainUserName = @"KeychainUserName";
NSString *const KeychainUserPassword = @"KeychainUserPassword";

@implementation ContentManager {
    NSOperation *_loginOperation;
    NSOperation *_changePassOperation;
    NSOperation *_bikesOperation;
    NSOperation *_bikeStateOperation;
    NSOperation *_returnOperation;
    NSOperation *_borrowOperation;
    
    struct {
        unsigned int authenticating:1;
    } _flags;
}

+ (instancetype)manager {
	static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
    });
    
	return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Accessors

- (BOOL)isLogged {
    return ([APIManager manager].accessToken != nil);
}

- (BOOL)isAuthenticating {
    return _flags.authenticating;
}

- (void)setUsingBike:(Bike *)usingBike {
    _usingBike = usingBike;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerDidChangeUsingBikeNotification object:self userInfo:nil];
    });
}

#pragma mark - Login / Logout methods

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    _flags.authenticating = 1;
    [self setKeychainObject:username forKey:KeychainUserName];
    [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerWillAuthenticateUserNotification object:self];
    
    __weak typeof(self)weakSelf = self;
    [_loginOperation cancel];
    _loginOperation = [[APIManager manager] POST:@"accounts/mine/login" parameters:@{@"username": username, @"password": password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [APIManager manager].accessToken = responseObject[@"apiKey"];
            
            [weakSelf bikeStateWithCompletion:^(Bike *bike, NSError *error) {
                if (!error) {
                    strongSelf->_usingBike = bike;
                }
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                [[[[UIApplication sharedApplication] windows] firstObject] setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"ContainerNavigationController"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerDidAuthenticateUserNotification object:weakSelf userInfo:nil];
                });
                
                if (completion) {
                    completion(nil);
                }
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)changePassword:(NSString *)password completion:(void (^)(NSError *error))completion {
    NSParameterAssert(password);
    
    [_changePassOperation cancel];
    _changePassOperation = [[APIManager manager] PUT:@"accounts/mine/password" parameters:@{@"newPassword" : password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)logout {
    [APIManager manager].accessToken = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [[[[UIApplication sharedApplication] windows] firstObject] setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerDidAuthenticateUserNotification object:self userInfo:nil];
    });
}

#pragma mark - Bikes methods

- (void)bikesWithLocation:(CLLocationCoordinate2D)location completion:(void (^)(NSArray *bikes, NSError *error))completion {
    //@"/bikes?lat=50.071667&lng=14.433804"
    [_bikesOperation cancel];
    _bikesOperation = [[APIManager manager] GET:[NSString stringWithFormat:@"bikes?lat=%f&lng=%f",location.latitude, location.longitude] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *bikes = @[].mutableCopy;
        NSArray *data = responseObject;
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [bikes addObject:[[Bike alloc] initWithDictionary:obj]];
        }];
        if (completion) {
            completion(bikes, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)bikeStateWithCompletion:(void (^)(Bike *bike, NSError *error))completion {
    
    [_bikeStateOperation cancel];
    _bikeStateOperation = [[APIManager manager] GET:@"bikes/mine" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion([[Bike alloc] initWithDictionary:responseObject], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)borrowBike:(Bike *)bike location:(CLLocationCoordinate2D)location completion:(void (^)(NSString *code, NSError *error))completion {
    NSParameterAssert(bike);
    
    [_borrowOperation cancel];
    
    __weak __typeof(self)weakSelf = self;
    _borrowOperation = [[APIManager manager] GET:[NSString stringWithFormat:@"bikes/lock-code?bikeCode=%@&lat=%f&lng=%f",bike.bikeCode, location.latitude, location.longitude] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf->_usingBike = bike;
        }
        if (completion) {
            completion(responseObject[@"lockCode"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)returnBike:(Bike *)bike location:(CLLocationCoordinate2D)location note:(NSString *)note completion:(void (^)(NSError *error))completion {
    
    NSDictionary *loc = @{
                            @"lat": @(location.latitude),
                            @"lng": @(location.longitude),
                            @"note": note ?: @""
                         };
    
    NSDictionary *params = @{
                             @"location": loc
                            };
    
    [_returnOperation cancel];
    
    __weak __typeof(self)weakSelf = self;
    _returnOperation = [[APIManager manager] PUT:[NSString stringWithFormat:@"bikes/%@/return",[bike.identifier stringValue]] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf->_usingBike = nil;
        }
        
        if (completion) {
            completion(nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

@end

@implementation ContentManager (Keychain)

- (NSMutableDictionary *)keychainQueryForKey:(NSString *)key {
    return @{ (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
              (__bridge id)kSecAttrService: key,
              (__bridge id)kSecAttrAccount: key,
              (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleAfterFirstUnlock }.mutableCopy;
}

- (void)setKeychainObject:(id)anObject forKey:(NSString *)aKey {
    NSParameterAssert(aKey);
    
    NSMutableDictionary *query = [self keychainQueryForKey:aKey];
    SecItemDelete((__bridge CFDictionaryRef)query);
    
    if (anObject) {
        query[(__bridge id)kSecValueData] = [NSKeyedArchiver archivedDataWithRootObject:anObject];
        SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }
}

- (void)removeKeychainObjectForKey:(NSString *)aKey {
    NSParameterAssert(aKey);
    
    NSMutableDictionary *query = [self keychainQueryForKey:aKey];
    SecItemDelete((__bridge CFDictionaryRef)query);
}

- (id)keychainObjectForKey:(NSString *)aKey {
    NSParameterAssert(aKey);
    
    id value = nil;
    NSMutableDictionary *query = [self keychainQueryForKey:aKey];
    CFDataRef data = NULL;
    
    query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&data) == noErr) {
        @try {
            value = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)data];
        }
        @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", aKey, e);
        }
    }
    
    if (data) {
        CFRelease(data);
    }
    
    return value;
}

@end
