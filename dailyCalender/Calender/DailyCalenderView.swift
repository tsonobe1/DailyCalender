//
//  ContentView.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2022/12/24.
//

import SwiftUI

class TimeBoxState: ObservableObject {
    @Published var isEditMode = false
    @Published var isMoveboxDown = false
    @Published var isNavigation = false
}

struct DailyCalenderView: View {
    @EnvironmentObject var timeBoxState: TimeBoxState
    
    @Namespace var namespace
    var tasks: [Task1]
    var ratio: [UUID: (xPositionRatio: CGFloat, widthRatio: CGFloat)]
    init() {
        self.tasks = makeDataSet()
        // initでgetTaskBox..を実行することで、
        self.ratio = getTaskBoxXAxisProperties(tasks: tasks)
    }
    
    @State var selectedTask: Task1 = Task1(name: "", startDate: Date(), endDate: Date(), id: UUID.init(), color: Color.blue)
    @State var hourTextWidth = CGFloat.zero
    @State var magnifyBy: CGFloat = 1
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // MARK: ⏱️ TimeLine View
                /// If you do not place a VStack with spacing:0, the position of the content to override will be shifted.
                VStack(spacing: 0){
                    ForEach(0..<24, id: \.self) { hour in
                        Group {
                            HStack(alignment: .center, spacing: 0){
                                // ⏱️ 00:00
                                Text("\(String(format: "%02d", hour)):00   ")
                                /// Use UIFont so that the width does not change depending on the character.
                                    .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 10.0, weight: .regular)))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .overlay(
                                        /// Get the width of the 00:00 part.
                                        GeometryReader { proxy in
                                            Color.clear
                                                .onAppear{
                                                    hourTextWidth = proxy.size.width
                                                }
                                        }
                                    )
                                // ⏱️ Divider
                                /// Generating multiple canvases inside a Canvas closure performs better than generating multiple Shapes
                                /// However, using ForEach outside of the Canvas closure to generate multiple canvases results in worse performance than multiple shape generation (especially memory usage)
                                /// So here we use Rectangle instead of Canvas.
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.primary.opacity(0.3))
                                    .frame(height: 1)
                                    .cornerRadius(10)
                            }
                            // ⏱️ Width per hour
                            .frame(height: 40 * magnifyBy, alignment: .top)
                        }
                        .overlay(
                            // ⏱️ Additional TimeLine (XX:30 --- . XX: 15 ---, XX:45 ---)
                            GeometryReader { proxy in
                                // MARK: Added XX:30, XX:15, XX:45 display depending on zoom factor
                                switch magnifyBy {
                                case 2...4:
                                    ColonDelimitedTimeDivider(hour: hour, time: 30, hourHeight: proxy.size.height)
                                case 4...50:
                                    ColonDelimitedTimeDivider(hour: hour, time: 30, hourHeight: proxy.size.height)
                                    ColonDelimitedTimeDivider(hour: hour, time: 15, hourHeight: proxy.size.height)
                                    ColonDelimitedTimeDivider(hour: hour, time: 45, hourHeight: proxy.size.height)
                                default:
                                    EmptyView()
                                }
                            }
                        )
                    }
                }
                // MARK: ⬜️ TimeBoxs
                .overlay{
                    GeometryReader { geoProxy in
                        Group {
                            // MARK: ⬜️ TimeBox
                            ForEach(tasks, id: \.self) { task in
                                /// When we create many canvas view by using foreach outside canvas's closure, it’s low performance than shape,
                                /// so I not use Canvas, I use Rectangle.
                                
                                TimeBoxView(
                                    // TODO: selectedTaskは後でFetched Result用に治す
                                    selectedTask: $selectedTask,
                                    namespace: namespace,
                                    task: task,
                                    hourTextWidth: hourTextWidth,
                                    proxy: geoProxy,
                                    ratio: ratio,
                                    magnifyBy: magnifyBy
                                )
                                
                                
                            }
                            // MARK: 🟦 Draggable TimeBox
                            if timeBoxState.isEditMode {
                                DraggableTimeBoxView(
                                    selectedTask: selectedTask,
                                    hourTextWidth: hourTextWidth,
                                    proxy: geoProxy,
                                    ratio: ratio,
                                    magnifyBy: magnifyBy
                                )
                            }
                        }
//                        .navigationDestination(isPresented: $timeBoxState.isNavigation, destination: {
//                            Text("\(selectedTask.name)")
//                        })
//                        .navigationTitle("2023/1/2")
                    }
                }
                .padding(5)
            }
//            .background(Color.black.gradient)

            .overlay(
                // Floating button
                VStack {  // --- 1
                    Spacer()
                    HStack { // --- 2
                        Spacer()
                        Button(action: {
                            if !timeBoxState.isEditMode {
                                withAnimation(){
                                    switch magnifyBy {
                                    case 1:
                                        magnifyBy = 2
                                    case 2:
                                        magnifyBy = 5
                                    default:
                                        magnifyBy = 1
                                    }
                                }
                            }
                        }, label: {
                            Text("× \(Int(magnifyBy))")
                                .foregroundColor(!timeBoxState.isEditMode ? Color.primary : Color.gray)
                                .font(.system(size: 16)) // --- 4
                                .frame(width: 54, height: 54)
                                .background(
                                    Circle()
                                        .fill(!timeBoxState.isEditMode ? Color.secondary : Color.gray)
                                        .opacity(0.5)
                                )
                                .cornerRadius(30.0)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0)) // --- 5
                        }
                        )
                    }
                }
            )
            .overlay(
                timeBoxState.isNavigation ?
                TaskDetailView(
                    selectedTask: $selectedTask,
                    namespace: namespace
                )
                : nil
            )
            
        }
    
    }
    
}
