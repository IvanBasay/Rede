//
//  ExtensionUINavigationBar.swift
//  Rede
//
//  Created by Иван Викторович on 21.04.2022.
//

import Foundation
import UIKit

extension UINavigationItem {
    
    func changeBarTo(appearence: BarAppearence) {
        if appearence == .black {
            UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:.default)
            UITabBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().backgroundImage = UIImage()
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: Color.white, .font: UIFont(name: "Nunito-Bold", size: 17)!]
            navBarAppearance.shadowImage = nil
            navBarAppearance.shadowColor = .clear
            navBarAppearance.backgroundColor = Color.black
            let backImage = UIImage(named: "back_icon")?.withRenderingMode(.alwaysTemplate).withTintColor(Color.white)
            navBarAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
            navBarAppearance.backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: -200, vertical: 0)
            navBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            UINavigationBar.appearance().tintColor = Color.white
            self.standardAppearance = navBarAppearance
            self.scrollEdgeAppearance = navBarAppearance
            self.compactAppearance = navBarAppearance
            if #available(iOS 15.0, *) {
                UINavigationBar.appearance().compactScrollEdgeAppearance = navBarAppearance
            }
        } else {
            UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:.default)
            UITabBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().backgroundImage = UIImage()
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: Color.black, .font: UIFont(name: "Nunito-Bold", size: 17)!]
            navBarAppearance.shadowImage = nil
            navBarAppearance.shadowColor = .clear
            navBarAppearance.backgroundColor = Color.white
            let backImage = UIImage(named: "back_icon")?.withRenderingMode(.alwaysTemplate).withTintColor(Color.black)
            navBarAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
            navBarAppearance.backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: -200, vertical: 0)
            navBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            UINavigationBar.appearance().tintColor = Color.black
            self.standardAppearance = navBarAppearance
            self.scrollEdgeAppearance = navBarAppearance
            self.compactAppearance = navBarAppearance
            if #available(iOS 15.0, *) {
                UINavigationBar.appearance().compactScrollEdgeAppearance = navBarAppearance
            }
        }
    }
    
    
}

enum BarAppearence {
    case white, black
}
