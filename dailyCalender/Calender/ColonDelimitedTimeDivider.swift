//
//  ColonDelimitedTimeDivider.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2022/12/28.
//

import SwiftUI

struct ColonDelimitedTimeDivider: View {
    var hour: Int
    var time: Int
    var hourHeight: CGFloat
    
    var body: some View {
        HStack {
            Text("\(String(format: "%02d", hour)):\(time)")
                .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 10.0, weight: .regular)))
                .opacity(0.4)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.secondary.opacity(0.3))
        }
        
        .offset(y: (hourHeight / 60 * CGFloat(time)))
    }
}
