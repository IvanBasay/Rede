//
//  StoryboardManager.swift
//  Tradelize
//
//  Created by Иван Викторович on 16.04.2021.
//

import UIKit

class StoryboardReferenceBuilder {
    private init() {}
    
    static let shared = StoryboardReferenceBuilder()
    
    func buildReference<VC: UIViewController>(forController controller: VC.Type, storyboard: Storyboard) -> VC? {
        guard let nextViewController = UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: String(describing: VC.self)) as? VC else { return nil }
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if topController == nextViewController {
                return nil
            }
        }
        return nextViewController
    }
    
    func buildCustomReference(nameID: String, storyboard: Storyboard) -> UIViewController? {
        let sb = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: nameID)
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if topController == vc {
                return nil
            }
        }
        return vc
    }
}

enum Storyboard: String {
    case main = "Main"
//    case sign = "Sign"
//    case feed = "Feed"
//    case details = "Details"
//    case settings = "Settings"
//    case search = "Search"
//    case profile = "Profile"
//    case socialTrading = "SocialTrading"
//    case flow = "Flow"
//    case notifications = "Notifications"
//    case positions = "Positions"
//    case onboarding = "Onboarding"
}
