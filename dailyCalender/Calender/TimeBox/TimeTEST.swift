//
//  TimeTEST.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/01.
//

import SwiftUI

struct TimeTEST: View {
    @GestureState var press = false
    @State var show = false

    var body: some View {
        Image(systemName: "camera.fill")
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .background(show ? Color.black : Color.blue)
            .mask(Circle())
            .scaleEffect(press ? 2 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6))
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .updating($press) { currentState, gestureState, transaction in
                        gestureState = currentState
                    }
                    .onEnded { value in
                        show.toggle()
                    }
            )
    }
}

struct TimeSets: View {
    @GestureState var pressed = false
    @State var progressValue: CGFloat = 0.0
    @State var isLongPressed = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 350, height: 100)
            .foregroundColor(.yellow)
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .updating($pressed, body: { currentState, gestureState, transaction in
                        gestureState = currentState
                    })
                    .onEnded { _ in
                        isLongPressed = true
                    }
            )
            .overlay (
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.purple)
                        .frame(width: pressed || isLongPressed ? proxy.size.width * 1.0 : proxy.size.width * 0.0)
                        .animation(.easeInOut, value: pressed)
                }
            )
    }
}


struct TimeTEST_Previews: PreviewProvider {
    static var previews: some View {
        TimeSets()
    }
}


