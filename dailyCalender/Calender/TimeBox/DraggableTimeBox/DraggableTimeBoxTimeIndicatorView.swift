//
//  DraggaleTimeBoxStartTimeIndicator.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2022/12/31.
//

import SwiftUI

// 🟦🕛 StartTime　Indicator
struct DraggableTimeBoxStartTimeIndicatorView: View {
    let selectedTask: Task1
    let hourTextWidth: CGFloat
    let proxy: GeometryProxy
    let ratio: [UUID: (xPositionRatio: CGFloat, widthRatio: CGFloat)]

    var diffYAxis: CGFloat
    var diffYAxisUpperSide: CGFloat
    
    var diffStartMinutes: Int
    var diffMinutes: Int
    
    var body: some View {
        Group {
            HStack(spacing: 0) {
                Text(dateTimeFormatter(date: Calendar.current.date(byAdding: .minute, value: diffStartMinutes + diffMinutes, to: selectedTask.startDate)!))
                    .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .bold)))
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.thinMaterial)
                    )
                    .frame(width:  hourTextWidth)
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [5]))
                    .frame(width:  (proxy.size.width - hourTextWidth), height: 1)
                    .opacity(0.8)
            }
        }
        .offset(y: proxy.size.height / 1_440 * dateToMinute(date: selectedTask.startDate) + diffYAxisUpperSide + diffYAxis)
        .foregroundColor(.red)
    }
}

// 🟦🕛 EndTime　Indicator
struct DraggableTimeBoxEndTimeIndicatorView: View {
    let selectedTask: Task1
    let hourTextWidth: CGFloat
    let proxy: GeometryProxy
    let ratio: [UUID: (xPositionRatio: CGFloat, widthRatio: CGFloat)]
    var magnifyBy: CGFloat

    var diffYAxis: CGFloat
    var diffYAxisLowerSide: CGFloat
    
    var diffEndMinutes: Int
    var diffMinutes: Int
    
    var body: some View {
        Group {
            HStack(spacing: 0) {
                Text(dateTimeFormatter(date: Calendar.current.date(byAdding: .minute, value: diffEndMinutes + diffMinutes, to: selectedTask.endDate)!))
                    .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .bold)))
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.thinMaterial)
                    )
                    .frame(width:  hourTextWidth)
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [5]))
                    .frame(width:  (proxy.size.width - hourTextWidth), height: 1)
                    .opacity(0.8)
            }
        }
        .offset(y: proxy.size.height / 1_440 * dateToMinute(date: selectedTask.endDate) + diffYAxisLowerSide + diffYAxis)
        .foregroundColor(.red)
        
    }
}
