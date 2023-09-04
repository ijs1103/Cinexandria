//
//  View+.swift
//  SwiftUI-BoilerPlate
//
//  Created by 이주상 on 2023/09/04.
//

import Foundation
import SwiftUI

extension View {
    func navigationWrapper() -> some View {
        return NavigationView { self }
    }
}
