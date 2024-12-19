//
//  CocktailDetailItem.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 19.12.24..
//

import SwiftUI

struct CocktailDetailItem: View {
    let iconName: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.orange)
            Text(label + ": ")
            Text(value)
                .font(.body)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.2))
                .foregroundColor(.orange)
                .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
