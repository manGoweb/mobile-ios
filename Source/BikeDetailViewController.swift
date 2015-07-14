//
//  BikeDetailViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 09/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
//import


class BikeDetailViewController: UIViewController, UIScrollViewDelegate {
    override func loadView() {
        let view = UIView()
        self.view = view
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
            make.bottom.equalTo(keyboardLayoutGuide)
        }
        self.scrollView = scrollView
        
        let container = UIView()
        scrollView.addSubview(container)
        container.snp_makeConstraints { make in
            make.width.equalTo(scrollView).offset(-(L.contentInsets.left + L.contentInsets.right))
            make.height.equalTo(scrollView).offset(500)
            make.edges.equalTo(scrollView).insets(L.contentInsets)
        }
        self.container = container
        
        let bikeIV = UIImageView(image: UIImage(imageIdentifier: .biggerBorrowBike))
        bikeIV.contentMode = .ScaleAspectFit
        container.addSubview(bikeIV)
        bikeIV.snp_makeConstraints { make in
            make.top.equalTo(container).offset(80)
            make.centerX.equalTo(container.snp_centerX)
        }
        
        let bikeTypeLabel = UILabel()
        container.addSubview(bikeTypeLabel)
        bikeTypeLabel.snp_makeConstraints { make in
            make.top.equalTo(bikeIV.snp_bottom).offset(L.verticalSpacing)
            make.left.right.equalTo(container)
        }
        self.bikeTypeLabel = bikeTypeLabel
        
        let bikeNameLabel = UILabel()
        container.addSubview(bikeNameLabel)
        bikeNameLabel.snp_makeConstraints { make in
            make.top.equalTo(bikeTypeLabel.snp_bottom).offset(20)
            make.left.right.equalTo(container)
        }
        self.bikeNameLabel = bikeNameLabel
        
        let warningLabel = UILabel()
        container.addSubview(warningLabel)
        warningLabel.snp_makeConstraints { make in
            make.top.equalTo(bikeNameLabel.snp_bottom).offset(L.verticalSpacing)
            make.centerX.equalTo(container.snp_centerX)
        }
        self.warningLabel = warningLabel
        
        let warningIV = UIImageView(image: UIImage(imageIdentifier: .yellowWarning))
        warningIV.contentMode = .ScaleAspectFit
        container.addSubview(warningIV)
        warningIV.snp_makeConstraints { make in
            make.top.equalTo(bikeNameLabel.snp_bottom).offset(L.verticalSpacing)
            make.right.equalTo(warningLabel.snp_left).offset(-L.verticalSpacing)
        }
        self.warningIV = warningIV
        
        let descriptionLabel = Theme.subTitleLabel()
        container.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints{ make in
            make.top.equalTo(warningLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.right.equalTo(container)
        }
        self.descriptionLabel = descriptionLabel
        
        let line1 = Theme.lineView()
        container.addSubview(line1)
        line1.snp_makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.height.equalTo(1)
        }
        
        let lastReturnLabel = UILabel()
        container.addSubview(lastReturnLabel)
        lastReturnLabel.snp_makeConstraints { make in
            make.top.equalTo(line1.snp_bottom).offset(20)
            make.left.right.equalTo(container)
        }
        self.lastReturnLabel = lastReturnLabel
        
        let calendarIV = UIImageView(image: UIImage(imageIdentifier: .calendar))
        calendarIV.contentMode = .ScaleAspectFit
        container.addSubview(calendarIV)
        calendarIV.snp_makeConstraints { make in
            make.top.equalTo(lastReturnLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(55)
        }
        
        let dateLabel = Theme.pinkLabel()
        container.addSubview(dateLabel)
        dateLabel.snp_makeConstraints { make in
            make.top.equalTo(lastReturnLabel.snp_bottom).offset(20)
            make.left.equalTo(calendarIV.snp_right).offset(L.horizontalSpacing)
        }
        self.dateLabel = dateLabel
        
        let clockIV = UIImageView(image: UIImage(imageIdentifier: .clock))
        container.addSubview(clockIV)
        clockIV.contentMode = .ScaleAspectFit
        clockIV.snp_makeConstraints { make in
            make.top.equalTo(lastReturnLabel.snp_bottom).offset(20)
            make.left.equalTo(dateLabel.snp_right).offset(40)
        }
        
        let timeLabel = Theme.pinkLabel()
        container.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { make in
            make.top.equalTo(lastReturnLabel.snp_bottom).offset(20)
            make.left.equalTo(clockIV.snp_right).offset(L.horizontalSpacing)
        }
        self.timeLabel = timeLabel
        
        let locationLabel = UILabel()
        container.addSubview(locationLabel)
        locationLabel.snp_makeConstraints { make in
            make.top.equalTo(dateLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.right.equalTo(container)
        }
        self.locationLabel = locationLabel
        
        let line2 = Theme.lineView()
        container.addSubview(line2)
        line2.snp_makeConstraints { make in
            make.top.equalTo(locationLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.height.equalTo(1)
        }
 
//        following 6 UIImageView will be downloaded from API
        let equipmentLabel = UILabel()
        container.addSubview(equipmentLabel)
        equipmentLabel.snp_makeConstraints { make in
            make.top.equalTo(line2.snp_bottom).offset(20)
            make.left.right.equalTo(container)
        }
        self.bikeEquipmentLabel = equipmentLabel
        
        let mudguardIV = UIImageView(image: UIImage(imageIdentifier: .mudguard))
        mudguardIV.contentMode = .ScaleAspectFit
        container.addSubview(mudguardIV)
        mudguardIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(container).offset(15)
        }
        self.mudguardIV = mudguardIV
        
        let basketIV = UIImageView(image: UIImage(imageIdentifier: .basket))
        basketIV.contentMode = .ScaleAspectFit
        container.addSubview(basketIV)
        basketIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(mudguardIV.snp_right).offset(15)
        }
        self.basketIV = basketIV
        
        let buzzerIV = UIImageView(image: UIImage(imageIdentifier: .buzzer))
        basketIV.contentMode = .ScaleAspectFit
        container.addSubview(buzzerIV)
        buzzerIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(basketIV.snp_right).offset(15)
        }
        self.buzzerIV = buzzerIV
        
        let backlightIV = UIImageView(image: UIImage(imageIdentifier: .backlight))
        backlightIV.contentMode = .ScaleAspectFit
        container.addSubview(backlightIV)
        backlightIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(buzzerIV.snp_right).offset(15)
        }
        self.backlightIV = backlightIV
        
        let frontlightIV = UIImageView(image: UIImage(imageIdentifier: .frontlight))
        frontlightIV.contentMode = .ScaleAspectFit
        container.addSubview(frontlightIV)
        frontlightIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(backlightIV.snp_right).offset(15)
        }
        self.frontlightIV = frontlightIV
        
        let trunkIV = UIImageView(image: UIImage(imageIdentifier: .trunk))
        trunkIV.contentMode = .ScaleAspectFit
        container.addSubview(trunkIV)
        trunkIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(frontlightIV.snp_right).offset(15)
        }
        self.trunkIV = trunkIV
        
        let moreInfoButton = TintingButton(titleAndImageTintedWith: .rekolaGreenColor(), activeTintColor: .rekolaGreenColor())
        container.addSubview(moreInfoButton)
        moreInfoButton.snp_makeConstraints { make in
            make.top.equalTo(trunkIV.snp_bottom).offset(L.verticalSpacing)
            make.width.equalTo(110)
            make.height.equalTo(44)
            make.centerX.equalTo(container.snp_centerX)
        }
        self.moreInfoButton = moreInfoButton
        
        let line3 = Theme.lineView()
        container.addSubview(line3)
        line3.snp_makeConstraints { make in
            make.top.equalTo(moreInfoButton.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.height.equalTo(1)
        }
        
        let problemsLabel = UILabel()
        container.addSubview(problemsLabel)
        problemsLabel.snp_makeConstraints { make in
            make.top.equalTo(line3.snp_bottom).offset(20)
            make.left.right.equalTo(container)
        }
        self.problemsLabel = problemsLabel
        
        let addProblemButton = Theme.pinkButton()
        container.addSubview(addProblemButton)
        addProblemButton.snp_makeConstraints { make in
            make.top.equalTo(problemsLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.height.equalTo(44)
        }
        self.addProblemButton = addProblemButton
        
        let moreInfoView = UIView()
        container.addSubview(moreInfoView)
//        moreInfoView.opaque = true
        moreInfoView.alpha = 0
        moreInfoView.snp_makeConstraints{ make in
            make.left.top.right.bottom.equalTo(container)
            make.height.equalTo(435)
        }
        self.moreInfoView = moreInfoView
        
        let infoEquipmentLabel = UILabel()
        moreInfoView.addSubview(infoEquipmentLabel)
        infoEquipmentLabel.snp_makeConstraints { make in
            make.top.equalTo(moreInfoView).offset(L.verticalSpacing)
            make.left.equalTo(moreInfoView).offset(L.horizontalSpacing)
        }
        self.infoEquipmentLabel = infoEquipmentLabel
        
        let infoMudguardIV = UIImageView(image: UIImage(imageIdentifier: .mudguard))
        moreInfoView.addSubview(infoMudguardIV)
        infoMudguardIV.contentMode = .ScaleAspectFit
        infoMudguardIV.snp_makeConstraints { make in
            make.top.equalTo(infoEquipmentLabel.snp_bottom).offset(20)
            make.left.equalTo(moreInfoView).offset(L.horizontalSpacing)
        }
        
        let infoBasketIV = UIImageView(image: UIImage(imageIdentifier: .basket))
        moreInfoView.addSubview(infoBasketIV)
        infoBasketIV.contentMode = .ScaleAspectFit
        infoBasketIV.snp_makeConstraints { make in
            make.top.equalTo(infoMudguardIV.snp_bottom).offset(20)
            make.left.equalTo(moreInfoView).offset(L.horizontalSpacing)
        }
        
        let infoBuzzerIV = UIImageView(image: UIImage(imageIdentifier: .buzzer))
        moreInfoView.addSubview(infoBuzzerIV)
        infoBuzzerIV.contentMode = .ScaleAspectFit
        infoBuzzerIV.snp_makeConstraints { make in
            make.top.equalTo(infoBasketIV.snp_bottom).offset(20)
            make.left.equalTo(moreInfoView).offset(L.horizontalSpacing)
        }
        
        let infoBacklightIV = UIImageView(image: UIImage(imageIdentifier: .backlight))
        moreInfoView.addSubview(infoBacklightIV)
        infoBacklightIV.contentMode = .ScaleAspectFit
        infoBacklightIV.snp_makeConstraints { make in
            make.top.equalTo(infoBuzzerIV.snp_bottom).offset(20)
            make.left.equalTo(moreInfoView).offset(L.horizontalSpacing)
        }
        
        let infoFrontlightIV = UIImageView(image: UIImage(imageIdentifier: .frontlight))
        moreInfoView.addSubview(infoFrontlightIV)
        infoFrontlightIV.contentMode = .ScaleAspectFit
        infoFrontlightIV.snp_makeConstraints { make in
            make.top.equalTo(infoBacklightIV.snp_bottom).offset(20)
            make.left.equalTo(moreInfoView).offset(L.horizontalSpacing)
        }
        
        let infoTrunkIV = UIImageView(image: UIImage(imageIdentifier: .trunk))
        moreInfoView.addSubview(infoTrunkIV)
        infoTrunkIV.contentMode = .ScaleAspectFit
        infoTrunkIV.snp_makeConstraints { make in
            make.top.equalTo(infoFrontlightIV.snp_bottom).offset(20)
            make.left.equalTo(moreInfoView).offset(L.horizontalSpacing)
        }
        
//        need to repair it (strings and position)Ç
        let infoMudguardLabel = UILabel()
        moreInfoView.addSubview(infoMudguardLabel)
        infoMudguardLabel.textAlignment = .Left
        infoMudguardLabel.text = "Blatniky"
        infoMudguardLabel.snp_makeConstraints { make in
            make.top.equalTo(infoEquipmentLabel.snp_bottom).offset(25)
            make.left.equalTo(infoMudguardIV.snp_right).offset(20)
        }
        
        let infoBasketLabel = UILabel()
        moreInfoView.addSubview(infoBasketLabel)
        infoBasketLabel.textAlignment = .Left
        infoBasketLabel.text = "Kosik"
        infoBasketLabel.snp_makeConstraints { make in
            make.top.equalTo(infoMudguardLabel.snp_bottom).offset(25)
            make.left.equalTo(infoBasketIV.snp_right).offset(20)
        }
        
        let infoBuzzerLabel = UILabel()
        moreInfoView.addSubview(infoBuzzerLabel)
        infoBuzzerLabel.textAlignment = .Left
        infoBuzzerLabel.text = "Zvonek"
        infoBuzzerLabel.snp_makeConstraints { make in
            make.top.equalTo(infoBasketLabel.snp_bottom).offset(25)
            make.left.equalTo(infoBuzzerIV.snp_right).offset(20)
        }
        
        let infoBacklightLabel = UILabel()
        moreInfoView.addSubview(infoBacklightLabel)
        infoBacklightLabel.textAlignment = .Left
        infoBacklightLabel.text = "Zadni svetla"
        infoBacklightLabel.snp_makeConstraints { make in
            make.top.equalTo(infoBuzzerLabel.snp_bottom).offset(25)
            make.left.equalTo(infoBacklightIV.snp_right).offset(20)
        }
        
        let infoFrontlightLabel = UILabel()
        moreInfoView.addSubview(infoFrontlightLabel)
        infoFrontlightLabel.textAlignment = .Left
        infoFrontlightLabel.text = "Predni svetla"
        infoFrontlightLabel.snp_makeConstraints { make in
            make.top.equalTo(infoBacklightLabel.snp_bottom).offset(25)
            make.left.equalTo(infoFrontlightIV.snp_right).offset(20)
        }
        
        let infoTrunkLabel = UILabel()
        moreInfoView.addSubview(infoTrunkLabel)
        infoTrunkLabel.textAlignment = .Left
        infoTrunkLabel.text = "Nosic"
        infoTrunkLabel.snp_makeConstraints { make in
            make.top.equalTo(infoFrontlightLabel.snp_bottom).offset(25)
            make.left.equalTo(infoTrunkIV.snp_right).offset(20)
        }
    }
    
    weak var scrollView: UIScrollView!
    weak var container: UIView!
    weak var bikeIV: UIImageView!
    weak var bikeTypeLabel: UILabel!
    weak var bikeNameLabel: UILabel!
    weak var warningIV: UIImageView!
    weak var warningLabel: UILabel!
    weak var descriptionLabel: UILabel!
    weak var lastReturnLabel: UILabel!
    weak var timeLabel: UILabel!
    weak var dateLabel: UILabel!
    weak var locationLabel: UILabel!
    weak var bikeEquipmentLabel: UILabel!
    weak var mudguardIV: UIImageView!
    weak var basketIV: UIImageView!
    weak var buzzerIV: UIImageView!
    weak var backlightIV: UIImageView!
    weak var frontlightIV: UIImageView!
    weak var trunkIV: UIImageView!
    weak var moreInfoButton: TintingButton!
    weak var problemsLabel: UILabel!
    weak var addProblemButton: UIButton!
    weak var moreInfoView: UIView!
    weak var infoEquipmentLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.tintColor = .rekolaPinkColor()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        
        deleteLineUnderNavBar()
        
        self.view.backgroundColor = .whiteColor()
        self.view.tintColor = .whiteColor()
        
        self.bikeTypeLabel.text = "Lady Favorit"
        self.bikeTypeLabel.textAlignment = .Center
        self.bikeTypeLabel.textColor = .rekolaPinkColor()
        self.bikeTypeLabel.font = UIFont.systemFontOfSize(14)
        
        self.bikeNameLabel.text = "Kníže Pupík Ignor"
        self.bikeNameLabel.textAlignment = .Center
        self.bikeNameLabel.font = UIFont.systemFontOfSize(27)
        
        self.warningLabel.text = "Pozor, nepojizdne!"
        self.warningLabel.textAlignment = .Center
        self.warningLabel.textColor = .rekolaWarningYellowColor()
        
        self.descriptionLabel.text = "Mestske kolo s nosicem, kosikem, protislapnou brzdou a nabojovou prevodovkou."
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.textAlignment = .Center
        
        self.lastReturnLabel.text = NSLocalizedString("BIKEDETAIL_lastReturn", comment: "")
        self.lastReturnLabel.textAlignment = .Center
        self.lastReturnLabel.font = UIFont.boldSystemFontOfSize(17)
        
        self.dateLabel.text = "15.06"
        self.timeLabel.text = "13:08"
        self.locationLabel.text = "Pred galerii Myslbek na rohu u znacky"
        self.locationLabel.textColor = .rekolaGrayTextColor()
        self.locationLabel.font = UIFont.systemFontOfSize(15)
        self.locationLabel.textAlignment = .Center
        
        self.bikeEquipmentLabel.text = NSLocalizedString("BIKEDETAIL_equipment", comment: "")
        self.bikeEquipmentLabel.textAlignment = .Center
        self.bikeEquipmentLabel.font = UIFont.boldSystemFontOfSize(17)
        
        self.moreInfoButton.setTitle(NSLocalizedString("BIKEDETAIL_moreInfo", comment: ""), forState: .Normal)
        self.moreInfoButton.layer.borderWidth = 1
        self.moreInfoButton.layer.borderColor = UIColor.rekolaGreenColor().CGColor
        self.moreInfoButton.layer.cornerRadius = 5
        self.moreInfoButton.addTarget(self, action: "viewMoreInfo", forControlEvents: .TouchUpInside)
        
        self.infoEquipmentLabel.text = NSLocalizedString("BIKEDETAIL_equipment", comment: "")
        
        self.problemsLabel.text = NSLocalizedString("BIKEDETAIL_problems", comment: "")
        self.problemsLabel.textAlignment = .Center
        self.problemsLabel.font = UIFont.boldSystemFontOfSize(17)
        
        self.addProblemButton.setTitle(NSLocalizedString("BIKEDETAIL_addProblem", comment: ""), forState: .Normal)
        self.addProblemButton.addTarget(self, action: "addProblemSegue", forControlEvents: .TouchUpInside)
    }
    
    func deleteLineUnderNavBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
    }
    
    func viewMoreInfo() {
        UIView.animateWithDuration(0.2, animations: {
            self.scrollView.backgroundColor = UIColor.rekolaBackgroundColor().colorWithAlphaComponent(0.3)
            self.moreInfoView.alpha = 1
            self.moreInfoView.backgroundColor = .whiteColor()
        })
    }
    
    func addProblemSegue() {
        let vc = AddProblemViewController()
        showViewController(vc, sender: nil)
    }
    
//    navigationBar settings
    func scrollViewDidScroll(scrollview: UIScrollView) {
        let color = UIColor.rekolaGreenColor()
        let changePoint = 50 as CGFloat
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > changePoint {
            let alpha = min(1, 1-((changePoint + 64 - offsetY)/64))
            self.navigationController?.navigationBar .lt_setBackgroundColor(color .colorWithAlphaComponent(alpha))
            self.navigationController?.navigationBar.tintColor = .whiteColor()
            
        } else {
            self.navigationController?.navigationBar .lt_setBackgroundColor(color .colorWithAlphaComponent(0))
            self.navigationController?.navigationBar.tintColor = .rekolaPinkColor()
            deleteLineUnderNavBar()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar .lt_reset()
    }
}