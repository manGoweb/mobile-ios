//
//  SignInViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 07/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SignInViewController: UIViewController, UITextFieldDelegate{
	override func loadView() {
		let view = UIView()
		view.backgroundColor = .rekolaPinkColor()
		self.view = view
		
		let iv = UIImageView(image: UIImage(imageIdentifier: .signInBike))
		iv.contentMode = .ScaleAspectFit
//        iv.setContentCompressionResistancePriority(500, forAxis: .Vertical)
		view.addSubview(iv)
		iv.snp_makeConstraints { make in
			make.top.lessThanOrEqualTo(view).offset(60)
			make.centerX.equalTo(view.snp_centerX)
            make.height.equalTo(self.view).multipliedBy(0.2)
        }
		self.bikeImageView = iv
		
		let emailTF = Theme.pinkTextField()
		view.addSubview(emailTF)
		emailTF.snp_makeConstraints { make in
			make.top.equalTo(iv.snp_bottom).offset(L.verticalSpacing)//.priority(250)
			make.left.equalTo(view).offset(L.horizontalSpacing)
			make.right.equalTo(view).offset(-L.horizontalSpacing)
			make.height.equalTo(43)
			make.top.greaterThanOrEqualTo(snp_topLayoutGuideBottom).offset(2)
		}
		self.emailTextField = emailTF
		
		let passwdTF = Theme.pinkTextField()
		view.addSubview(passwdTF)
		passwdTF.snp_makeConstraints { make in
			make.top.equalTo(emailTF.snp_bottom).offset(L.verticalSpacing)
			make.right.equalTo(view).offset(-L.horizontalSpacing)
			make.left.equalTo(view).offset(L.horizontalSpacing)
			make.height.equalTo(43)
		}
		self.passwordTextField = passwdTF
		
		let signInButton = Theme.whiteButton()
		signInButton.backgroundColor = .whiteColor()
		signInButton.layer.cornerRadius = 4
		view.addSubview(signInButton)
		signInButton.snp_makeConstraints { make in
			make.top.equalTo(passwdTF.snp_bottom).offset(L.verticalSpacing)
			make.left.equalTo(view).offset(L.horizontalSpacing)
			make.right.equalTo(view).offset(-L.horizontalSpacing)
			make.height.equalTo(47)
		}
		self.signInButton = signInButton
		
		let register = UIButton()
		register.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		register.titleLabel?.font = UIFont.systemFontOfSize(14)
		view.addSubview(register)
		register.snp_makeConstraints { make in
			make.top.greaterThanOrEqualTo(signInButton.snp_bottom)
			make.top.equalTo(signInButton.snp_bottom).offset(L.verticalSpacing).priorityLow()
			make.left.right.equalTo(view)
		}
		self.registerButton = register
		
		let forgotPasswd = UIButton()
		forgotPasswd.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		forgotPasswd.titleLabel?.font = UIFont.systemFontOfSize(14)
		view.addSubview(forgotPasswd)
		forgotPasswd.snp_makeConstraints { make in
			make.top.equalTo(register.snp_bottom)
			make.left.right.equalTo(view)
			make.bottom.lessThanOrEqualTo(keyboardLayoutGuide)
		}
		self.forgotPasswd = forgotPasswd
		
		let ackeeIm = UIImageView(image: UIImage(imageIdentifier: .ackee))
		view.addSubview(ackeeIm)
        ackeeIm.contentMode = .ScaleAspectFit
		ackeeIm.snp_makeConstraints { make in
			make.top.equalTo(forgotPasswd.snp_bottom).offset(L.verticalSpacing)
			make.left.right.equalTo(view)
		}
		self.ackeeImage = ackeeIm
	}
	
	
	weak var bikeImageView: UIImageView!
	weak var emailTextField: UITextField!
	weak var passwordTextField: UITextField!
	weak var signInButton: UIButton!
	weak var registerButton: UIButton!
	weak var forgotPasswd: UIButton!
	weak var ackeeImage: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.emailTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("SIGNIN_email", comment: ""),
			attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
		emailTextField.returnKeyType = .Next
		
		self.passwordTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("SIGNIN_passwd", comment: ""),
			attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.passwordTextField.secureTextEntry = true
		passwordTextField.returnKeyType = .Go
		
        self.signInButton.setTitle(NSLocalizedString("SIGNIN_signin", comment: ""), forState: .Normal)
		self.signInButton.addTarget(self, action: "signIn:", forControlEvents: .TouchUpInside)
		
		self.registerButton.setTitle(NSLocalizedString("SIGNIN_register", comment: ""), forState: .Normal)
		
		self.forgotPasswd.setTitle(NSLocalizedString("SIGNIN_lostPasswd", comment: ""), forState: .Normal)
		forgotPasswd.addTarget(self, action: "forgotButtonTapped:", forControlEvents: .TouchUpInside)
		
		let emailEmpty = merge([emailTextField.rac_textSignal().toSignalProducer(), emailTextField.rac_valuesForKeyPath("text", observer: self).toSignalProducer()])
			|> ignoreError
			|> map { ($0 as! String).isEmpty }
		let pwEmpty = merge([passwordTextField.rac_textSignal().toSignalProducer(), passwordTextField.rac_valuesForKeyPath("text", observer: self).toSignalProducer()])
			|> ignoreError
			|> map { ($0 as! String).isEmpty }
		
		signInButton.rac_enabled <~ combineLatest([emailEmpty, pwEmpty, loggingIn.producer])
			|> map { args in !(args[0] || args[1] || args[2])	}
		
		
		emailTextField.delegate = self
		passwordTextField.delegate = self
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		switch textField {
		case emailTextField:
			passwordTextField.becomeFirstResponder()
			return false
		case passwordTextField:
			if(signInButton.enabled) { //app logic shouldnt be dependent on view state, but im lazy
				self.signIn(textField)
				return true
			}else{
				return true
			}

		default: return true
		}
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	var loggingIn = MutableProperty(false)
	
	func signIn(sender: AnyObject?) {
		loggingIn.value = true
		API.login(username: emailTextField.text, password: passwordTextField.text).start(completed: {
			self.loggingIn.value = false
			UIView.performWithoutAnimation{
				view.endEditing(true)
			}
			let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
			
			let vc = UINavigationController(rootViewController: LockViewController())
			let vc2 = UINavigationController(rootViewController: MapViewController())
			let vc3 = UINavigationController(rootViewController: ProfileViewController())
			
			let item = TabItem(controller: vc, images: UIImage.toggleImage(UIImage.ImagesForToggle.Lock))
			let item2 = TabItem(controller: vc2, images: UIImage.toggleImage(UIImage.ImagesForToggle.Map))
			let item3 = TabItem(controller: vc3, images: UIImage.toggleImage(UIImage.ImagesForToggle.Profile))
			
			let tabBar = ACKTabBarController(items: [item,item2,item3])
			UIView.transitionWithView(delegate.window!, duration: 0.2, options: .TransitionCrossDissolve, animations: {
				delegate.window!.rootViewController = tabBar
				}, completion: nil)
			
			delegate.window!.makeKeyAndVisible()
			}, error: { error in
				self.loggingIn.value = false
				self.handleError(error)
				//TODO: k erroru neni grafika a api zatim error nikdy nevrati
		})
	}
	
	func forgotButtonTapped(sender: UIButton) {
		view.endEditing(true)
		let vc = ResetPasswordViewController()
		presentViewController(vc, animated: true, completion: nil)
	}
}
