//
//  TaskDetailSteps.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/11.
//

import SwiftUI

struct TaskDetailStepView: View {
    @Binding var selectedTask: Task1
    @Binding var sampleDates5: [sampleDate5]
    
    @State private var hourTextWidth: CGFloat = 0
    @State private var hourTextHeight: CGFloat = 0
    @State private var dividerWidth: CGFloat = 0
    @State private var magnify: CGFloat = 5
    
    var totalStepsDuration: CGFloat {
        var dulations = 0
        for i in sampleDates5 {
            dulations += i.minute
        }
        return CGFloat(dulations)
    }
    
    var isTotalStepsDurationLessThanTaskDuration: Bool {
        totalStepsDuration < caluculateTimeInterval(startDate: selectedTask.startDate, endDate: selectedTask.endDate)
    }
    
    var body: some View {
        ScrollView{
            Group {
                // 🎚️ MARK: Each Step Duration < Task Duration
                /// If the variable "isTotalStepsDurationLessThanTaskDuration" is false, then swap the values of "🪜" and "⏰".
                /// We will compare the total duration of the task (the difference between the end and start times) with the total duration of all the steps,
                /// and set the height of the ScrollView to the larger value, whether it is the task duration or the total duration of all the steps.
                if isTotalStepsDurationLessThanTaskDuration{
                    /// ⏰ Tasks Start and End Time + Divider
                    TaskDurationTimelineView(
                        selectedTask: selectedTask,
                        hourTextWidth: hourTextWidth,
                        magnify: magnify
                    )
                    /// 🪜 Task's Step's End Time + Divider
                    .overlay(
                        TaskEachStepEndTimeLineView(
                            hourTextWidth: $hourTextWidth,
                            hourTextHeight: $hourTextHeight,
                            dividerWidth: $dividerWidth,
                            sampleDates5: sampleDates5,
                            magnify: magnify,
                            selectedTask: selectedTask
                        )
                        ,alignment: .topLeading
                    )
                }
                // 🎚️ MARK: Each Step Duration > Task Duration
                else {
                    /// 🪜 <-- swap
                    TaskEachStepEndTimeLineView(
                        hourTextWidth: $hourTextWidth,
                        hourTextHeight: $hourTextHeight,
                        dividerWidth: $dividerWidth,
                        sampleDates5: sampleDates5,
                        magnify: magnify,
                        selectedTask: selectedTask
                    )
                    /// ⏰ <-- swap
                    .overlay(
                        TaskDurationTimelineView(
                            selectedTask: selectedTask,
                            hourTextWidth: hourTextWidth,
                            magnify: magnify
                        )
                        ,alignment: .topLeading
                    )
                }
            }
            /// ☑️ Task's Step's List
            .overlay(
                TaskEachStepListView(
                    sampleDates5: $sampleDates5,
                    hourTextWidth: hourTextWidth,
                    hourTextHeight: hourTextHeight,
                    dividerWidth: dividerWidth,
                    magnify: magnify
                )
                ,alignment: .topLeading
            )
            
        }
        .padding(5)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
    }
}



struct TaskDurationTimelineView: View {
    var selectedTask: Task1
    var hourTextWidth: CGFloat
    var magnify: CGFloat
    
    fileprivate func TimeAndDivider(_ date: Date) -> HStack<TupleView<(Text, some View)>> {
        return HStack {
            // ⏱️ 00:00
            Text("\(dateTimeFormatter(date: date))")
                .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .heavy)))
                .foregroundColor(selectedTask.color.opacity(0.8))
            // ⏱️ Divider
            RoundedRectangle(cornerRadius: 10)
                .fill(selectedTask.color)
                .frame(height: 1.5)
                .cornerRadius(10)
        }
    }
    
    var body: some View {
        VStack(spacing: 0){
            TimeAndDivider(selectedTask.startDate)
            Spacer()
            TimeAndDivider(selectedTask.endDate)
        }
        .brightness(0.8)
        .frame(height: magnify * (caluculateTimeInterval(startDate: selectedTask.startDate, endDate: selectedTask.endDate)) + (hourTextWidth / 2.4))
    }
    
}

struct TaskEachStepEndTimeLineView: View {
    @Binding var hourTextWidth: CGFloat
    @Binding var hourTextHeight: CGFloat
    @Binding var dividerWidth: CGFloat
    var sampleDates5: [sampleDate5]
    var magnify: CGFloat
    var selectedTask: Task1
    
    /// returns step durations by adding the minutes of each element in sampleDates5
    var stepDurations: [Int] {
        /// using reduce function to iterate over sampleDates5 array, initial value is [0]
        /// and it will append total duration of step to array
        return sampleDates5.reduce(into: [0]) { $0.append($0.last! + $1.minute) }
    }

    var body: some View {
        VStack(spacing: 0){
            ForEach(Array(sampleDates5.enumerated()), id: \.element ) { index, date3 in
                Group {
                    HStack{
                        let _ = print("\(stepDurations)")
                        // ⏱️ 00:00
                        Text("\(dateTimeFormatter(date: Calendar.current.date(byAdding: .minute, value: stepDurations[index+1], to: selectedTask.startDate)!))")
                            .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .regular)))
                            .foregroundColor(.primary.opacity(0.7))
                            .overlay(
                                GeometryReader { proxy in
                                    Color.clear
                                        .onAppear{
                                            hourTextWidth = proxy.size.width
                                            hourTextHeight = proxy.size.height
                                        }
                                }
                            )
                        // ⏱️ Divider
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.primary)
                            .frame(height: 1)
                            .cornerRadius(10)
                            .overlay(
                                GeometryReader { proxy in
                                    Color.clear
                                        .onAppear{
                                            dividerWidth = proxy.size.width
                                        }
                                }
                            )
                    }
                    // ⏱️ Width per hour
                    .frame(height: magnify * CGFloat(date3.minute), alignment: .bottomLeading)
                    .offset(y: hourTextHeight)
                }
            }
            Rectangle().fill(.clear).frame(height: 50)
        }
        
    }
}

struct TaskEachStepListView: View {
    @Binding var sampleDates5: [sampleDate5]
    @Environment(\.editMode) var editMode

    
    var hourTextWidth: CGFloat
    var hourTextHeight: CGFloat
    var dividerWidth: CGFloat
    var magnify: CGFloat
    
    /// 行入れ替え処理
    func rowReplace(_ from: IndexSet, _ to: Int) {
        sampleDates5.move(fromOffsets: from, toOffset: to)
    }
    
    var body: some View {
        List {
            ForEach(Array(sampleDates5.enumerated()), id: \.element ) { index, date3 in
                Group {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Material.thinMaterial.opacity(0.8))
                        .overlay(
                            Text("\(date3.name)")
                                .foregroundColor(Color.primary)
                                .font(.caption)
                                .opacity(0.8)
                                .minimumScaleFactor(0.1)
                                .padding(5)
                            ,alignment: .topLeading
                        )
                        .listRowInsets(EdgeInsets())
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                print("delete action.")
                                sampleDates5.remove(at: index)
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                        }
                        
                        .frame(height: magnify * CGFloat(date3.minute), alignment: .topLeading)
                }
                .listRowBackground(Color.clear)

            }
            .onMove(perform: rowReplace)
        }
        .offset(x: hourTextWidth + hourTextWidth / 2, y: 0)
        .frame(width: dividerWidth - hourTextWidth / 4)
        .toolbar {
                        EditButton()
                    }
        .scrollDisabled(true)
        .environment(\.defaultMinListRowHeight, 0)
        .offset(y: hourTextHeight/2)
        .listStyle(.plain)
        
        
    }
}

