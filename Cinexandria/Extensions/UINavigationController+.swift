//
//  UINavigationController+.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/10.
//

import SwiftUI

extension UINavigationController {
    // back button 텍스트 제거 
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
