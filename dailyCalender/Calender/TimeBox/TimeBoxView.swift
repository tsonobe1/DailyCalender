//
//  TimeBox.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2022/12/31.
//

import SwiftUI

struct TimeBoxView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var timeBoxState: TimeBoxState
    @Binding var selectedTask: Task1
    
    let namespace: Namespace.ID
    
    // From Parent View
    let task: Task1
    let hourTextWidth: CGFloat
    let proxy: GeometryProxy
    let ratio: [UUID: (xPositionRatio: CGFloat, widthRatio: CGFloat)]
    let magnifyBy: CGFloat
    
    @State var sheet = false
    var tappedTimeBox: Bool { task.id == selectedTask.id && timeBoxState.isMoveboxDown }

    
    var body: some View {
        Group {
            // ⬜️ Box
            RoundedRectangle(cornerRadius: 5)
                .fill(timeBoxState.isEditMode ? task.color.gradient.opacity(0.4) : task.color.gradient.opacity(0.6))
                .matchedGeometryEffect(id: task, in: namespace)
            
            
            
            // ⬜️🔤 Task Title
                .overlay(
                    VStack {
                        Text("\(task.name)")
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .minimumScaleFactor(0.2)
                            .opacity(timeBoxState.isEditMode ? 0.4 : 1)
                            .offset(x: 5)
                            .padding(5)
                    }
//                        .matchedGeometryEffect(id: task.id.uuidString + "DETAILS", in: namespace)
                    ,alignment: .topLeading
                )
            // ⬜️🖼️ GridSpace
                .border(colorScheme == .dark ? Color.black : Color.white, width: 0.55)
        }

        
        // ⬜️🧐 TimeBox Position, Size Adjustment
        .frame(
            width: (proxy.size.width - hourTextWidth) * ratio[task.id]!.widthRatio,
            height: proxy.size.height / 1_440 * caluculateTimeInterval(startDate: task.startDate, endDate: task.endDate)
        )
        .offset(
            x: hourTextWidth + (proxy.size.width - hourTextWidth) * ratio[task.id]!.xPositionRatio,
            // + 6.5 is the height position adjustment of Timeline Divider and TaskBox edge
            // tappedTimeBox is for to animation timebox down then expand.
            y: tappedTimeBox ? proxy.size.height / 1_440 * dateToMinute(date: task.startDate) + 30 : proxy.size.height / 1_440 * dateToMinute(date: task.startDate) + 6.5
        )
//        .zIndex(tappedTimeBox ? 100 : 0)
        
        // ⬜️🤌 Gesture
        /// "LongPressGesture(simultaneous) then TapGesture(highPriority) can be to working the scrollview's scroll.
        .gesture(
            LongPressGesture()
                .onEnded { _ in
                    withAnimation(.linear(duration: 0.1)){
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        selectedTask = task
                            timeBoxState.isEditMode.toggle()
                    }
                }
        )
        .highPriorityGesture(
            TapGesture().onEnded { _ in
                if timeBoxState.isEditMode {
                    print("Unresponsive")

                }else{
                    print("WAW!!")
                    selectedTask = task
                    // TimeBox's Down then Expands Animetion
                    withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.3)){
                        timeBoxState.isMoveboxDown = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12){
                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 1, blendDuration: 1)){
                            timeBoxState.isNavigation = true
                        }
                    }
                }
            }
        )
        // MARK: Task Detail

    }
}
 
