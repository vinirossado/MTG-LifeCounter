//
//  SixPlayerLayout.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//

import SwiftUI

struct SixPlayerGridView: View {
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 4
            let columnWidth = (geometry.size.width - 2 * spacing) / 3
            let rowHeight = (geometry.size.height - spacing) / 2

            VStack(spacing: spacing) {
                HStack(spacing: spacing) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(UIColor.systemGray6))
                            .frame(width: columnWidth, height: rowHeight)
                    }
                }
                HStack(spacing: spacing) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(UIColor.systemGray6))
                            .frame(width: columnWidth, height: rowHeight)
                    }
                }
            }
        }
    }
}

#Preview {
    SixPlayerGridView()
}
