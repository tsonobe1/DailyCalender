//
//  DraggableTimeBox.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2022/12/31.
//

import SwiftUI

struct DraggableTimeBoxView: View {
    @EnvironmentObject var timeBoxState: TimeBoxState
    var selectedTask: Task1
    
    // From Parent View
    let hourTextWidth: CGFloat
    let proxy: GeometryProxy
    let ratio: [UUID: (xPositionRatio: CGFloat, widthRatio: CGFloat)]
    let magnifyBy: CGFloat
    
    // Moving Timebox Properties
    @State private var diffXAxis = CGFloat.zero
    @State private var lastDiffXAxis = CGFloat.zero
    
    @State private var diffYAxis = CGFloat.zero
    @State private var lastDiffYAxis = CGFloat.zero
    
    @State private var diffYAxisUpperSide = CGFloat.zero
    @State private var lastDiffYAxisUpperSide = CGFloat.zero

    @State private var diffYAxisLowerSide = CGFloat.zero
    @State private var lastDiffYAxisLowerSide = CGFloat.zero
    
    @State private var diffMinutes = Int.zero
    @State private var lastDiffMinutes = Int.zero
    
    @State private var diffStartMinutes = Int.zero
    @State private var lastDiffStartMinutes = Int.zero

    @State private var diffEndMinutes = Int.zero
    @State private var lastDiffEndMinutes = Int.zero
    
    @State private var modifiedStartDate = Date()
    @State private var modifiedEndDate = Date()
    
    //
    @State private var startDayIsSame = true
    @State private var endDayIsSame = true
    @State private var isOnOutsideLeft = false
    @State private var isOnOutsideRight = false
    
    var isNotAcceptTaskBoxDragChanges: Bool {
        !startDayIsSame || !endDayIsSame || isOnOutsideLeft || isOnOutsideRight
    }
    
    @GestureState var pressing = false
    @State var isLongPressed = false
    
    var body: some View {
        Group {
            // 🟦 TimeBox
            RoundedRectangle(cornerRadius: 5)
                .fill(isNotAcceptTaskBoxDragChanges ? selectedTask.color.gradient : selectedTask.color.gradient)
                .opacity(0.6)
                .shadow(color: .gray.opacity(8), radius: 3, x: 5, y: 5)
            // 🟦🔤 Task Title
                .overlay(
                    Text("\(selectedTask.name)")
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.5)
                        .offset(x: 5)
                        .padding(5),
                    alignment: .topLeading
                )
                .background(
                    Text("LongPress to save")
                        .minimumScaleFactor(0.1)
                        .opacity(0.5)
                        .font(.title3)
                        .bold()
                )
        }
        // MARK: 🟦 LongPress Elapsed Time Indicator
        .overlay (
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: 5)
                    .fill(selectedTask.color.gradient)
                    .opacity(0.6)
                /// When user's hand is released, animation speed is 5 times,
                    .animation(pressing ? .linear : .linear.speed(10), value: pressing)
                /// "pressing" is true when long pressing DraggableTimeBox, when it doesn't false.
                /// "isLongPressed" is true when finished long press DraggableTimeBox.
                    .frame(width: pressing || isLongPressed ? proxy.size.width * 1.0 : proxy.size.width * 0.0)
            }
        )
        // 🟦🧐 TimeBox Position, Size Adjustment
            .frame(
                width:  (proxy.size.width - hourTextWidth) * (ratio[selectedTask.id]?.widthRatio ?? 1),
                height: proxy.size.height / 1_440 * caluculateTimeInterval(startDate: selectedTask.startDate, endDate: selectedTask.endDate) + diffYAxisLowerSide - diffYAxisUpperSide
            )
            .offset(
                x: hourTextWidth + (proxy.size.width - hourTextWidth) * (ratio[selectedTask.id]?.xPositionRatio ?? 1) + diffXAxis,
                // + 6.5 is the height position adjustment of Timeline Divider and TaskBox edge
                y: proxy.size.height / 1_440 * dateToMinute(date: selectedTask.startDate) + 6.5 + diffYAxis + diffYAxisUpperSide
            )
        // 🟦💥 Generate Impact Feedback when TimeBox is moved for a specific number of minutes (the minutePeriod argument of roundToMultipleMinutes).
            .onChange(of: modifiedStartDate){ value in
                switch magnifyBy {
                case 1.0...5.0: UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                case 5.0... : UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                default: print("impact default")
                }
            }
        // 🟦🤌 Gesture
            .gesture(
                // 🟦🤌 Disable Draggable TimeBox
                LongPressGesture()
                    .updating($pressing, body: { currentState, gestureState, transaction in
                        gestureState = currentState
                    })
                    .onEnded { _ in
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            isLongPressed = true
                        withAnimation(.spring()) {
                            timeBoxState.isEditMode = false
                        }
                    }
            )
            .simultaneousGesture(
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
                        diffXAxis = value.translation.width + lastDiffXAxis
                        diffYAxis = roundedMovedProperties.movedPosition + lastDiffYAxis
                        diffMinutes = roundedMovedProperties.movedMinute + lastDiffMinutes
                        
                        // Obtain the value by adding movedMinute to StartDate and EndDate and keep it
                        modifiedStartDate = Calendar.current.date(byAdding: .minute, value: diffMinutes + diffStartMinutes, to: selectedTask.startDate)!
                        modifiedEndDate = Calendar.current.date(byAdding: .minute, value: diffMinutes + diffEndMinutes, to: selectedTask.endDate)!
                        startDayIsSame = selectedTask.startDate.isSameDay(otherDay: modifiedStartDate)
                        endDayIsSame = selectedTask.endDate.isSameDay(otherDay: modifiedEndDate)
                    }
                    .onEnded{ _ in
                        lastDiffYAxis = diffYAxis
                        lastDiffXAxis = diffXAxis
                        lastDiffMinutes = diffMinutes
                        // TODO: Write Task Update
                    }
            )
        // MARK: 🟦🕛 Time Indicator
        // 🟦🕛 StartTime　
            .overlay(
                DraggableTimeBoxStartTimeIndicatorView(
                    selectedTask: selectedTask,
                    hourTextWidth: hourTextWidth,
                    proxy: proxy,
                    ratio: ratio,
                    diffYAxis: diffYAxis,
                    diffYAxisUpperSide: diffYAxisUpperSide,
                    diffStartMinutes: diffStartMinutes,
                    diffMinutes: diffMinutes
                ),
                alignment: .topLeading
            )
        // 🟦🕛 EndDate
            .overlay(
                DraggableTimeBoxEndTimeIndicatorView(
                    selectedTask: selectedTask,
                    hourTextWidth: hourTextWidth,
                    proxy: proxy,
                    ratio: ratio,
                    magnifyBy: magnifyBy,
                    diffYAxis: diffYAxis,
                    diffYAxisLowerSide: diffYAxisLowerSide,
                    diffEndMinutes: diffEndMinutes,
                    diffMinutes: diffMinutes
                ),
                alignment: .topLeading
            )
        // MARK: 🟦🕛🎚️ Time Slider
        // 🟦🕛🎚️ StartTime
            .overlay(
                DraggableTimeBoxStartTimeSliderView(
                    selectedTask: selectedTask,
                    hourTextWidth: hourTextWidth,
                    proxy: proxy,
                    ratio: ratio,
                    magnifyBy: magnifyBy,
                    diffYAxis: diffYAxis,
                    diffMinutes: diffMinutes,
                    diffYAxisUpperSide: $diffYAxisUpperSide,
                    lastDiffYAxisUpperSide: $lastDiffYAxisUpperSide,
                    diffStartMinutes: $diffStartMinutes,
                    lastDiffStartMinutes: $lastDiffStartMinutes,
                    modifiedStartDate: $modifiedStartDate,
                    startDayIsSame: $startDayIsSame
                ),
                alignment: .topLeading
            )
        // 🟦🕛👆 EndTime
            .overlay(
                DraggableTimeBoxEndTimeSliderView(
                    selectedTask: selectedTask,
                    hourTextWidth: hourTextWidth,
                    proxy: proxy,
                    ratio: ratio,
                    magnifyBy: magnifyBy,
                    diffYAxis: diffYAxis,
                    diffMinutes: diffMinutes,
                    diffYAxisLowerSide: $diffYAxisLowerSide,
                    lastDiffYAxisLowerSide: $lastDiffYAxisLowerSide,
                    diffEndMinutes: $diffEndMinutes,
                    lastDiffEndMinutes: $lastDiffEndMinutes,
                    modifiedEndDate: $modifiedEndDate,
                    endDayIsSame: $endDayIsSame
                ),
                alignment: .topLeading
            )
    }
}


struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
