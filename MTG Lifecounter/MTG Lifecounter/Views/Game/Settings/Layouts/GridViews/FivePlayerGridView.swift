//
//  FivePlayerLayout.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//

import SwiftUI

struct FivePlayerGridView: View {
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 4
            let width = (geometry.size.width - 2 * spacing) / 3
            let height = (geometry.size.height - spacing) / 2
            
            HStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(UIColor.systemGray4))
                        .frame(width: width, height: height)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(UIColor.systemGray4))
                        .frame(width: width, height: height)
                }
                
                VStack(spacing: spacing) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(UIColor.systemGray4))
                        .frame(width: width, height: height)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(UIColor.systemGray4))
                        .frame(width: width, height: height)
                }
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray4))
                    .frame(width: width, height: geometry.size.height)
            }
        }
    }
}

#Preview {
    FivePlayerGridView()
}
