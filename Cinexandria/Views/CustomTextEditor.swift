//
//  CustomTextEditor.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/09.
//

import SwiftUI

struct TextEditorConfig {
    let label: String
    let bindingText: Binding<String>
    let bindingTextCount: Int
    let placeholder: String
    let limit: Int
}

struct CustomTextEditor: View {
    
    let config: TextEditorConfig
    @Binding var text: String
    @State var textCount: Int
    
    init(config: TextEditorConfig) {
        self.config = config
        _text = config.bindingText
        _textCount = State(initialValue: config.bindingTextCount)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(config.label).customFont(size: 14, weight: .semibold)
                Spacer()
                Text("\(textCount)/\(config.limit)").customFont(size: 14, weight: .semibold)
            }
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text).customFont(size: 16, weight: .semibold).foregroundColor(.white).padding(.vertical, 12).padding(.horizontal, 8).overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(.white ,lineWidth: 1.0)
                ).lineSpacing(10).frame(maxHeight: 250).onChange(of: text) { value in
                    if text.count > config.limit {
                        text = String(text.prefix(config.limit))
                        textCount = config.limit
                    }
                    textCount = value.count
                }
                if text.isEmpty {
                    Text(config.placeholder).customFont(color: .gray, size: 16, weight: .semibold).padding(.top, 12).padding(.horizontal, 9)
                }
            }
        }
    }
}
