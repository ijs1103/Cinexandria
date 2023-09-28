//
//  Utils.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/28.
//

import Foundation
import UIKit

final class Utils {
    static let shared = Utils()
    private init() {}
    
    @MainActor
    func getRootVC(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }?.rootViewController
        if let navigationController = controller as? UINavigationController {
            return getRootVC(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return getRootVC(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return getRootVC(controller: presented)
        }
        return controller
    }
}
