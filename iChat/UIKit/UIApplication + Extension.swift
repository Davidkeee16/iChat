//
//  UIApplication + Extension.swift
//  iChat
//
//  Created by David Puksanskis on 20/08/2025.
//

import UIKit

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared
        .connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.windows.first(where: {$0.isKeyWindow}) }
        .first?.rootViewController) -> UIViewController? {
            
            if let nav = base as? UINavigationController {
                return getTopViewController(base: nav.visibleViewController)
            } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            } else if let presented = base?.presentedViewController {
                return getTopViewController(base: presented)
            }
            return base
        }
}
