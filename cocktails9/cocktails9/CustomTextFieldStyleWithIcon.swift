//
//  CustomTextFieldStyle.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 2.12.24..
//

import Foundation
import SwiftUI

struct CustomTextFieldStyleWithIcon: TextFieldStyle {
    let icon: String
    let borderColor: Color = .gray
    let backgroundColor: Color = .white

    func _body(configuration: TextField<_Label>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(borderColor)
            configuration
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 8).fill(backgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}
