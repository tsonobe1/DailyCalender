//
//  TaskDetailDateTime.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/12.
//

import SwiftUI

struct TaskDetailDateTimeView: View {
    @Binding var selectedTask: Task1
    @State private var showStartDatePicker = false
    @State private var showEndDatePicker = false

    let f = DateFormatter()

    
    var body: some View {
        Group {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "calendar.badge.clock")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.red, .primary)
                
                VStack(alignment: .leading) {
                    // MARK: StartDate, EndDate
                    Text(dateFormatter(date: selectedTask.startDate))
                    HStack(alignment: .lastTextBaseline,  spacing: 5) {
                        Text("from")
                        Text(dateTimeFormatter(date: selectedTask.startDate))
                            .font(.title2.bold())
                            .strikethrough(selectedTask.startDate >= selectedTask.endDate ? true : false)
                            .underline(showStartDatePicker ? true : false)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    if showEndDatePicker {
                                        showEndDatePicker.toggle()
                                        showStartDatePicker.toggle()
                                    } else {
                                        showStartDatePicker.toggle()
                                    }
                                }
                            }
                        Text("to")
                        Text(dateTimeFormatter(date: selectedTask.endDate))
                            .font(.title2.bold())
                            .strikethrough(selectedTask.startDate >= selectedTask.endDate ? true : false)
                            .underline(showEndDatePicker ? true : false)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    if showStartDatePicker {
                                        showStartDatePicker.toggle()
                                        showEndDatePicker.toggle()
                                    } else {
                                        showEndDatePicker.toggle()
                                    }
                                }
                            }
                    }
                    
                            Text("The start time should be earlier than the end time.")
                                .opacity(selectedTask.startDate >= selectedTask.endDate ? 1 : 0)
                    
                }
            }
            .font(.footnote)
            .foregroundColor(.white)
            .padding([.top, .bottom])
            
            // Date Picker
            Group {
                // MARK: DatePicker
                if showStartDatePicker {
                    DatePicker("", selection: $selectedTask.startDate, displayedComponents: .hourAndMinute)
                    
                }else if showEndDatePicker {
                    DatePicker("", selection: $selectedTask.endDate, displayedComponents: .hourAndMinute)
                    
                }
            }
            .datePickerStyle(WheelDatePickerStyle())
            .colorScheme(.dark)
        }
    }
}

struct TaskDetailDateTime_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailDateTimeView(selectedTask: .constant(Task1(name: "TEST TASK", startDate: Date(), endDate: Date(), id: UUID(), color: .red)))
    }
}
