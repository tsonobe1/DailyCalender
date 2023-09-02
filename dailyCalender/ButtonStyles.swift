//
//  ButtonStyles.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/08.
//

import SwiftUI

struct StepOneTapInput: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .font(.callout)
            .background(Material.thick)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
