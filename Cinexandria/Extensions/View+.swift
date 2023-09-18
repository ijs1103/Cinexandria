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

// 특정 모서리만 corner-radius 적용하기
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func customFont(color: Color = Color("FontPrimary"), size: CGFloat, weight: Font.Weight) -> some View {
        return self.foregroundColor(color).font(.system(size: size, weight: weight))
    }
}
// 그라데이션 및 다크 오버레이 적용
extension View {
    func BackDropFilter() -> some View {
        return self.overlay(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)).overlay(.black.opacity(0.35))
    }
}
