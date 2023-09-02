//
//  ListTest.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/09.
//

import SwiftUI

struct sampleDate1: Identifiable, Hashable {
    var name: String
    var minute: Int
    var id: UUID
}

func makeTask() -> Task1{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = "2022-12-06"
    let date = dateFormatter.date(from: dateString)!
    let startDate = Calendar.current.date(byAdding: .minute, value: 600, to: date)!
    let endDate = Calendar.current.date(byAdding: .minute, value: 700, to: date)!
    
    let task = Task1(name: "Test", startDate: startDate, endDate: endDate, id: UUID(), color: .purple)
    return task
}
    
struct ListTest: View {
    @State var sampleDates1 = [
        sampleDate(name: "TEST1", minute: 20, id: UUID()),
        sampleDate(name: "TEST2", minute: 30, id: UUID()),
        sampleDate(name: "TEST3", minute: 15, id: UUID()),
        sampleDate(name: "TEST4", minute: 15, id: UUID()),
        sampleDate(name: "TEST4", minute: 10, id: UUID())
    ]
    var task  = makeTask()
    @State private var hourTextWidth = CGFloat.zero
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(task.color.gradient)
            .colorMultiply(Color(UIColor.systemGray))
            .ignoresSafeArea()
            .overlay(
                VStack{
                    Text("\(task.name)")
                        .font(.title)
                    
                        ScrollView {
                            VStack(spacing: 0){
                                ForEach(sampleDates1) { date in
                                    HStack{
                                        Text("00:00 ")
                                            .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 14.0, weight: .regular)))
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
                                        Rectangle()
                                            .fill(.primary.opacity(0.3))
                                            .frame(height: 1)
                                    }
                                    .frame(height: 5 * CGFloat(date.minute), alignment: .top)
                                    
                                }
                            }
                            .overlay(
                                GeometryReader { proxy in
                                    List {
                                        ForEach(Array(sampleDates1.enumerated()), id: \.element ) { index, date in
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.black.opacity(0.3))
                                                .overlay(
                                                    Text("\(date.name)")
                                                )
                                                .listRowInsets(EdgeInsets())
                                                .listRowBackground(
                                                    Color.clear
                                                )
                                                .frame(height: proxy.size.height / 90 * CGFloat(date.minute))
                                                .swipeActions(edge: .trailing) {
                                                    Button(role: .destructive) {
                                                        print("delete action.")
                                                        sampleDates1.remove(at: index)
                                                    } label: {
                                                        Image(systemName: "trash.fill")
                                                    }
                                                }
                                        }
                                    }
                                    .offset(y: 9)
                                    .offset(x: hourTextWidth + 10)
                                    .frame(width: proxy.size.width - hourTextWidth - 10)
//                                    .opacity(0.5)
                                    .listStyle(.plain)
                                    
                                }
                                ,
                                alignment: .topLeading
                            )
                        }
                        .padding(5)

                    
                }
            )
    }
}

struct ListTest_Previews: PreviewProvider {
    static var previews: some View {
        ListTest()
    }
}
