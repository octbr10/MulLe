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
    @IBOutlet weak var onboardingView: OnboardingView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "Hotels")!,
                           title: "Hotels",
                           description: "All hotels and hostels are sorted by hospitality rating",
                           pageIcon: UIImage(named: "Hotels")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "Hotels")!,
                           title: "Hotels",
                           description: "We carefully verify all banks before add them into the app",
                           pageIcon: UIImage(named: "Hotels")!,
                           color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "Hotels")!,
                           title: "Hotels",
                           description: "All local stores are categorized for your convenience",
                           pageIcon: UIImage(named: "Hotels")!,
                           color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStartedButton.isHidden = false

        setupPaperOnboardingView()

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

        func onboardingWillTransitonToIndex(_ index: Int) {
            //getStartedButton.isHidden = index == 2 ? false : true
        }

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
    
    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let onboarding = PaperOnboarding()
//
//        onboarding.dataSource = self
//        onboardingView.delegate = self
//
//        onboarding.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(onboarding)
//
//
//
//        // add constraints
//        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
//          let constraint = NSLayoutConstraint(item: onboarding,
//                                              attribute: attribute,
//                                              relatedBy: .equal,
//                                              toItem: view,
//                                              attribute: attribute,
//                                              multiplier: 1,
//                                              constant: 0)
//          view.addConstraint(constraint)
//
//        }
//        onboarding.bringSubviewToFront(getStartedButton)
//    }
//
//
//    func onboardingItemsCount() -> Int {
//        3
//    }
//
//
//    func onboardingItem(at index: Int) -> OnboardingItemInfo {
//        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha:1)
//        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha:1)
//        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha:1)
//
//        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
//        let descirptionFont = UIFont(name: "AvenirNext-Bold", size: 18)!
//        let ro  = UIImage(named: "rocket") as UIImage?
//
//        return [
//          OnboardingItemInfo(informationImage: ro!,
//                                        title: "Rocket",
//                                  description: "Cotton",
//                                     pageIcon: ro!,
//                                        color: backgroundColorOne,
//                                   titleColor: UIColor.white,
//                             descriptionColor: UIColor.white,
//                                    titleFont: titleFont,
//                              descriptionFont: descirptionFont),
//
//          OnboardingItemInfo(informationImage: ro!,
//                                         title: "title",
//                                   description: "Dessert ",
//                                      pageIcon: ro!,
//                                         color: backgroundColorTwo,
//                                    titleColor: UIColor.white,
//                              descriptionColor: UIColor.white,
//                                     titleFont: titleFont,
//                               descriptionFont: descirptionFont),
//
//         OnboardingItemInfo(informationImage: ro!,
//                                      title: "title",
//                                description: "Chocolate",
//                                   pageIcon: ro!,
//                                      color: backgroundColorThree,
//                                 titleColor: UIColor.white,
//                           descriptionColor: UIColor.white,
//                                  titleFont: titleFont,
//                            descriptionFont: descirptionFont)
//          ][index]
//
////return [(imageName: rocket, title: "title", description: "description", iconName: rocket , color: backgroundColorOne, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descirptionFont)][index]
//
//
//    }
//
//
//    func onboardingConfigurationItem(item: OnboardingContentViewItem, index: Int) {
//
//    //    item.titleLabel?.backgroundColor = .redColor()
//    //    item.descriptionLabel?.backgroundColor = .redColor()
//    //    item.imageView = ...
//      }
//
//    func onboardingWillTransitonToIndex(_ index: Int) {
////        if index == 1 {
////            if self.getStartedButton.alpha == 1 {
////                UIView.animate(withDuration: 0.2, animations: {
////                    self.getStartedButton.alpha = 0
////                })
////            }
////        }
//    }
//
//    func onboardingDidTransitonToIndex(_ index: Int) {
//
////        if index == 2 {
////            UIView.animate (withDuration: 0.4, animations: {
////                self.getStartedButton.alpha = 1
////            })
////        }
//    }
//

