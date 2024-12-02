//
//  GridItem.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 2.12.24..
//

import SwiftUI

struct GridItem: View {
    
    var body: some View {
        
        
        VStack(alignment: .leading){
            
//            Image()
//                .renderingMode(.original)
//                .resizable()
//                .frame(width: 155, height: 155)
//                .cornerRadius(5)
            
            HStack {
                Text("koktel")
                    .foregroundStyle(.primary)
                    .font(.caption)
                
            }
        }
        .padding(.all, 5)
    }
}

#Preview {
    GridItem()
}
