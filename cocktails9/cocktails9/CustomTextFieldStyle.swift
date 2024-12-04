//
//  CustomTextFieldStyle.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 2.12.24..
//

import Foundation
import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    
    let icon: String
    
    func _body(configuration: TextField<_Label>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            configuration
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}
