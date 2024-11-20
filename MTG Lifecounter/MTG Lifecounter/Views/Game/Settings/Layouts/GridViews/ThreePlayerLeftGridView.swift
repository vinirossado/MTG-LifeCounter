//
//  ThreePlayerLayoutLeft.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//

import SwiftUI

struct ThreePlayerLeftGridView: View {
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 4
            let width = (geometry.size.width - spacing) / 2
            let height = (geometry.size.height - spacing) / 2
            
            HStack(spacing: spacing) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray6))
                    .frame(width: width, height: geometry.size.height)
                
                VStack(spacing: spacing) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(UIColor.systemGray6))
                        .frame(width: width, height: height)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(UIColor.systemGray6))
                        .frame(width: width, height: height)
                }
            }
        }
    }
}

#Preview {
    ThreePlayerLeftGridView()
}
