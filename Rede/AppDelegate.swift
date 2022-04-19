//
//  AppDelegate.swift
//  Rede
//
//  Created by Иван Викторович on 14.04.2022.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        
        if !UDKey.isNotFirstLaunch {
            RealmManager.shared.setupFirstLaunchRealm()
            UDKey.isNotFirstLaunch = true
        }
                
        if UDKey.currency == .unknown {
            UDKey.currency = .uah
        }
        
        UILabel.appearance(whenContainedInInstancesOf: [UIDatePicker.self]).textColor = Color.gray
        UILabel.appearance(whenContainedInInstancesOf: [UIDatePicker.self]).font = UIFont(name: "Nunito-Bold", size: 14)
        
        configuteNavigationBar()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses = [SwapVC.self]
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = []
        
        return true
    }
    
  
    
    private func configuteNavigationBar() {

        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:.default)
        

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: Color.black, .font: UIFont(name: "Nunito-Bold", size: 17)!]
        navBarAppearance.shadowImage = nil
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = Color.white
        navBarAppearance.setBackIndicatorImage(UIImage(named: "back_icon"), transitionMaskImage: UIImage(named: "back_icon"))
        navBarAppearance.backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: -200, vertical: 0)
        navBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        UINavigationBar.appearance().tintColor = Color.black
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

}

enum Currency: String, PersistableEnum {
    case uah = "₴"
    case usd = "$"
    case unknown = "Unknown"
}

