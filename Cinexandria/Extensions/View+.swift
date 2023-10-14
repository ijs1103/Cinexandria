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
    
    func loadingWrapper(_ loadingState: LoadingState) -> some View {
        self.redacted(reason: loadingState == .loading ? .placeholder : []).allowsHitTesting(!(loadingState == .loading))
    }
    
    // 특정 모서리만 corner-radius 적용하기
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    // 커스텀 폰트
    func customFont(color: Color = Color("FontPrimary"), size: CGFloat, weight: Font.Weight) -> some View {
        return self.foregroundColor(color).font(.system(size: size, weight: weight))
    }
    // 이미지에 그라데이션 및 다크 오버레이 적용
    func BackDropFilter() -> some View {
        return self.overlay(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)).overlay(.black.opacity(0.35))
    }
    // List의 scroll을 disable <= iOS 15
    func listScrollDisable() -> some View {
        if #available(iOS 16.0, *) {
            return self
                .scrollDisabled(true)
        } else {
            return self
                .simultaneousGesture(DragGesture(minimumDistance: 0), including: .all)
        }
    }
    
    // 조건부 modifier
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func shadowedStyle() -> some View {
        self
            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
            .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
