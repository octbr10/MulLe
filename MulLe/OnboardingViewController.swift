//
//  OnboardingViewController.swift
//  MulLe
//
//  Created by Jeeyoung Park on 12.09.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController{
  
//
    @IBOutlet weak var getStartedButton: UIButton!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: Asset.hotels.image,
                           title: "Speech to Text",
                           description: "Mul-Le is a recorder player designed specifically for a language learner to improve speaking. It enables you to check the precision of you speaking for yourself by converting your speech to text.",
                           pageIcon: Asset.key.image,
                           color: UIColor(red: 217/255, green:72/255, blue: 89/255, alpha: 1.00),
                           //color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: Asset.banks.image,
                           title: "Listen your speaking",
                           description: "Mul-Le enables you to listen your speacking in an enjoyable way. It plays your speech automatically right after recording. To listen a sentence or stop listening, please just tab the sentence.",
                           pageIcon: Asset.wallet.image,
                           color: UIColor(red: 106/255, green:166/255, blue: 211/255, alpha: 1.00),
                           //color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: Asset.stores.image,
                           title: "Folder",
                           description: "Record your speech, sentence by sentence. Manage recordings by a folder. It is easier to re-record a sentence instead of a whole page or a whole dialogue",
                           pageIcon: Asset.shoppingCart.image,
                           color: UIColor(red: 168/255, green:200/255, blue: 78/255, alpha: 1.00),
                           //color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.isHidden = false

        setupPaperOnboardingView()

        view.bringSubviewToFront(getStartedButton)
  
        
    }
    
    
    @IBAction func gotStarted(_ sender: Any) {

        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onboardingComplete")
        userDefaults.synchronize()
        print("onboardingComplete: ", userDefaults.bool(forKey: "onboardingComplete"))
    }
    
    
        private func setupPaperOnboardingView() {
            let onboarding = PaperOnboarding()
            onboarding.delegate = self
            onboarding.dataSource = self
            onboarding.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(onboarding)
            onboarding.bringSubviewToFront(getStartedButton)


            // Add constraints
            for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
                let constraint = NSLayoutConstraint(item: onboarding,
                                                    attribute: attribute,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: attribute,
                                                    multiplier: 1,
                                                    constant: 0)
                view.addConstraint(constraint)
            }
        }
    }

    // MARK: Actions
    extension OnboardingViewController {

        @IBAction func skipButtonTapped(_: UIButton) {
            print(#function)
        }
    }

    // MARK: PaperOnboardingDelegate
    extension OnboardingViewController: PaperOnboardingDelegate {

//        func onboardingWillTransitonToIndex(_ index: Int) {
//            getStartedButton.isHidden = index == 2 ? false : true
//        }

        func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
            
//            item.titleCenterConstraint?.constant = 100
//            item.descriptionCenterConstraint?.constant = 100
//
//             configure item
//
//            item.titleLabel?.backgroundColor = .redColor()
//            item.descriptionLabel?.backgroundColor = .redColor()
//            item.imageView = ...
        }
    }

    // MARK: PaperOnboardingDataSource
    extension OnboardingViewController: PaperOnboardingDataSource {

        func onboardingItem(at index: Int) -> OnboardingItemInfo {
            return items[index]
        }

        func onboardingItemsCount() -> Int {
            return 3
        }
        
//            func onboardinPageItemRadius() -> CGFloat {
//                return 2
//            }
//
//            func onboardingPageItemSelectedRadius() -> CGFloat {
//                return 10
//            }
//            func onboardingPageItemColor(at index: Int) -> UIColor {
//                return [UIColor.white, UIColor.red, UIColor.green][index]
//            }
    }


    //MARK: Constants
    private extension OnboardingViewController {
        
        static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    }
    
    

