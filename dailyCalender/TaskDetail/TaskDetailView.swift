//
//  TaskDetail.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/02.
//

import SwiftUI

struct sampleDate5: Identifiable, Hashable {
    var name: String
    var minute: Int
    var id: UUID
}



func makeTask5() -> Task1{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = "2022-12-06"
    let date = dateFormatter.date(from: dateString)!
    let startDate = Calendar.current.date(byAdding: .minute, value: 600, to: date)!
    let endDate = Calendar.current.date(byAdding: .minute, value: 690, to: date)!
    
    let task = Task1(name: "Sed ut perspiciatis unde omnis iste natus", startDate: startDate, endDate: endDate, id: UUID(), color: .red)
    return task
}



struct TaskDetailView: View {
    
    @EnvironmentObject var timeBoxState: TimeBoxState
    @Binding var selectedTask: Task1
    
    let namespace: Namespace.ID
    @State var animeteContent = false
    
    @State private var taskDetail = "Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    @State private var imapct = ""
    

    @State private var isTappedDetail = false
    
    @State private var step = ""
        @State private var minute = 0
    
    @State private var steps = ["Lorem ipsum dolor sit amet consectetur lorem ipsum dolor sit ame", "Lorem ipsum dolor sit amet consectetur lorem ipsum dolor sit ame"]
    @State private var onTapSteps = ["😴 Rest", "😴 Rest", "😴 Rest", "😴 Rest", "😴 Rest"]

    @FocusState private var isFocused: Bool
    @State private var isExpandStepOneTapInput = false
    
    @State var sampleDates5 = [
        sampleDate5(name: "dignissimos ducimus qui blanditiis praesentium", minute: 30, id: UUID()),
        sampleDate5(name: "qui blanditiis praesentium", minute: 15, id: UUID()),
        sampleDate5(name: "blanditiis praesentium", minute: 15, id: UUID()),
        sampleDate5(name: "accusamus et iusto odio ", minute: 10, id: UUID()),
        sampleDate5(name: "At vero eos  qui blanditiis praesentium", minute: 15, id: UUID()),
        sampleDate5(name: "dignissimos ducimus blanditiis praesentium", minute: 30, id: UUID())
    ]
    
    
    var body: some View {
        // MARK: Task Detail
        
        RoundedRectangle(cornerRadius: 5)
            .fill(selectedTask.color.gradient)
            .colorMultiply(Color(UIColor.systemGray))
            .matchedGeometryEffect(id: selectedTask, in: namespace)
            .ignoresSafeArea()
            .overlay(
                VStack(alignment: .leading) {
                
                    /// Title
                    TaskDetailTitleView(title: $selectedTask.name)
                    /// 📅 Calender symbol + Date
                    TaskDetailDateTimeView(selectedTask: $selectedTask)
                    /// Steps
                    TaskDetailStepView(selectedTask: $selectedTask, sampleDates5: $sampleDates5)
                    
                    Group {
                        TextField("Step", text: $step)
                            .focused($isFocused)
                        
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Close") {
                                        isFocused = false
                                    }
                                }
                            }
                    }
                    
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack {
                                    ForEach(onTapSteps, id: \.self) { onTapStep in
                                        
                                        // Button
                                        Button {
                                            sampleDates5.append(sampleDate5(name: onTapStep, minute: 5, id: UUID()))
                                        } label: {
                                            HStack(alignment: .lastTextBaseline) {
                                                Text(onTapStep)
                                                VStack {
                                                    Text("5") +
                                                    Text("min")
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                        .buttonStyle(StepOneTapInput())
                                    }
                                    
                                }
                            }
                            Spacer()
                            
                            Button{
                                isExpandStepOneTapInput.toggle()
                            } label: {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                            }
                        }
                   
                    
                    
                    
                    // ✅ Done
//                    HStack {
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Material.thinMaterial)
//                            .frame(width: 170, height: 40)
//                            .onTapGesture {
//                                withAnimation(.easeInOut(duration: 0.4)){
//                                    timeBoxState.isNavigation = false
//                                    timeBoxState.isMoveboxDown = false
//                                }
//                            }
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Material.thinMaterial)
//                            .frame(width: 170, height: 40)
//
//                    }
                }
                    .opacity(animeteContent ? 1 : 0)
                //                    .offset(y: animeteContent ? 0 : 100)
                    .animation(.easeInOut(duration: 0.5).delay(0.1), value: animeteContent)
                //                    .scaleEffect(x: animeteContent ? 1 : 0.0001, anchor: .leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding()
                
            )
            .onAppear{
                withAnimation(.easeInOut.delay(0.2)){
                    animeteContent = true
                }
            }
    }
}




