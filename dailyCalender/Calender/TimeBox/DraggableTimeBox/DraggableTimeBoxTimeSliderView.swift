//
//  DraggaleTimeBoxTimeSlider.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2022/12/31.
//

import SwiftUI


struct DraggableTimeBoxStartTimeSliderView: View {
    let selectedTask: Task1
    let hourTextWidth: CGFloat
    let proxy: GeometryProxy
    let ratio: [UUID: (xPositionRatio: CGFloat, widthRatio: CGFloat)]
    var magnifyBy: CGFloat

    var diffYAxis: CGFloat
    var diffMinutes: Int

    @Binding var diffYAxisUpperSide: CGFloat
    @Binding var lastDiffYAxisUpperSide: CGFloat
    
    @Binding var diffStartMinutes: Int
    @Binding var lastDiffStartMinutes: Int
    
    @Binding var modifiedStartDate: Date
    @Binding var startDayIsSame: Bool
    
    var body: some View {
        Circle()
            .fill(.white.gradient)
            .frame(width: 30, height: 30)
            .offset(
                x: proxy.size.width - hourTextWidth,
                y: proxy.size.height / 1_440 * dateToMinute(date: selectedTask.startDate) + diffYAxisUpperSide + diffYAxis - 23
            )
            .gesture(
                // 🟦🤌 Drag TimeBox
                DragGesture()
                    .onChanged{ value in
                        var roundedMovedProperties = roundToMultipleMinutes(value.translation.height, proxy.size.height, 15)
                        switch magnifyBy {
                        case 1.0: break
                        case 2.0: roundedMovedProperties = roundToMultipleMinutes(value.translation.height, proxy.size.height, 5)
                        case 5.0: roundedMovedProperties = roundToMultipleMinutes(value.translation.height, proxy.size.height, 1)
                        default: roundedMovedProperties = roundToMultipleMinutes(value.translation.height, proxy.size.height, 15)
                        }
                        diffYAxisUpperSide = roundedMovedProperties.movedPosition + lastDiffYAxisUpperSide
                        diffStartMinutes = roundedMovedProperties.movedMinute + lastDiffStartMinutes
                        
                        // Obtain the value by adding movedMinute to StartDate and EndDate and keep it
                        modifiedStartDate = Calendar.current.date(byAdding: .minute, value: diffMinutes + diffStartMinutes, to: selectedTask.startDate)!
                        startDayIsSame = selectedTask.startDate.isSameDay(otherDay: modifiedStartDate)

                    }
                    .onEnded{ _ in
                        lastDiffYAxisUpperSide = diffYAxisUpperSide
                        lastDiffStartMinutes = diffStartMinutes
                        // TODO: Write Task Update
                    }
            )
        // scrollView上でDragGestureがしやすくなる
            .simultaneousGesture(
                LongPressGesture()
                    .onEnded { _ in
                    }
            )
        
    }
}

struct DraggableTimeBoxEndTimeSliderView: View {
    let selectedTask: Task1
    let hourTextWidth: CGFloat
    let proxy: GeometryProxy
    let ratio: [UUID: (xPositionRatio: CGFloat, widthRatio: CGFloat)]
    var magnifyBy: CGFloat

    var diffYAxis: CGFloat
    var diffMinutes: Int

    @Binding var diffYAxisLowerSide: CGFloat
    @Binding var lastDiffYAxisLowerSide: CGFloat
    
    @Binding var diffEndMinutes: Int
    @Binding var lastDiffEndMinutes: Int
    
    @Binding var modifiedEndDate: Date
    @Binding var endDayIsSame: Bool
    
    var body: some View {
        Circle()
            .fill(.white.gradient)
            .frame(width: 30, height: 30)
            .offset(
                x: hourTextWidth,
                y: proxy.size.height / 1_440 * dateToMinute(date: selectedTask.endDate) + diffYAxisLowerSide + diffYAxis + 7
            )
            .gesture(
                // 🟦🤌 Drag TimeBox
                DragGesture()
                    .onChanged{ value in
                        var roundedMovedProperties = roundToMultipleMinutes(value.translation.height, proxy.size.height, 15)
                        switch magnifyBy {
                        case 1.0: break
                        case 2.0: roundedMovedProperties = roundToMultipleMinutes(value.translation.height, proxy.size.height, 5)
                        case 5.0: roundedMovedProperties = roundToMultipleMinutes(value.translation.height, proxy.size.height, 1)
                        default: roundedMovedProperties = roundToMultipleMinutes(value.translation.height, proxy.size.height, 15)
                        }
                        diffYAxisLowerSide = roundedMovedProperties.movedPosition + lastDiffYAxisLowerSide
                        diffEndMinutes = roundedMovedProperties.movedMinute + lastDiffEndMinutes
                        
                        // Obtain the value by adding movedMinute to StartDate and EndDate and keep it
                        modifiedEndDate = Calendar.current.date(byAdding: .minute, value: diffMinutes + diffEndMinutes, to: selectedTask.endDate)!
                        endDayIsSame = selectedTask.endDate.isSameDay(otherDay: modifiedEndDate)

                    }
                    .onEnded{ _ in
                        lastDiffYAxisLowerSide = diffYAxisLowerSide
                        lastDiffEndMinutes = diffEndMinutes
                        // TODO: Write Task Update
                    }
            )
        // scrollView上でDragGestureがしやすくなる
            .simultaneousGesture(
                LongPressGesture()
                    .onEnded { _ in
                    }
            )
        
    }
}
