//
//  CustomTextField.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/03.
//

import SwiftUI

struct TextFieldConfig {
    let label: String
    let defaultText: Binding<String>
    let isDisabled: Bool
    let limit: Int?
}

struct CustomTextField: View {
    
    let config: TextFieldConfig
    @Binding var text: String
    
    init(config: TextFieldConfig) {
        self.config = config
        _text = config.defaultText
    }
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(config.label).customFont(size: 14, weight: .semibold)
                Spacer()
                if let limit = config.limit {
                    Text("\(text.count)/\(limit)").customFont(size: 14, weight: .semibold)
                }
            }
            TextField("변경할 닉네임을 입력.", text: $text).disableAutocorrection(true).disabled(config.isDisabled).frame(height: 45)
                .foregroundColor(config.isDisabled ? .gray : .white)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(config.isDisabled ? .gray : .white ,lineWidth: 1.0)
                )
        }
    }
}
