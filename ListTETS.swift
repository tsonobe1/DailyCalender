//
//  ListTETS.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/09.
//

import SwiftUI

struct sampleDate2: Identifiable, Hashable {
    var name: String
    var minute: Int
    var id: UUID
}



func makeTask1() -> Task1{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = "2022-12-06"
    let date = dateFormatter.date(from: dateString)!
    let startDate = Calendar.current.date(byAdding: .minute, value: 600, to: date)!
    let endDate = Calendar.current.date(byAdding: .minute, value: 700, to: date)!
    
    let task = Task1(name: "Test", startDate: startDate, endDate: endDate, id: UUID(), color: .purple)
    return task
}

struct ListTETS: View {
    @State var sampleDates2 = [
        sampleDate2(name: "TEST1", minute: 20, id: UUID()),
        sampleDate2(name: "TEST2", minute: 30, id: UUID()),
        sampleDate2(name: "TEST3", minute: 15, id: UUID()),
        sampleDate2(name: "TEST4", minute: 15, id: UUID()),
        sampleDate2(name: "TEST4", minute: 10, id: UUID())
    ]
    var task  = makeTask1()
    @State private var hourTextWidth = CGFloat.zero
    @State private var hourTextHeight = CGFloat.zero
    
    @State private var offset = CGFloat.zero
    
    var body: some View {
     Rectangle()
            .fill(.purple.gradient)
            .colorMultiply(Color(UIColor.systemGray))
            .ignoresSafeArea()
            .overlay(
                VStack {
                 Text("TEST")
                    Spacer()
                    
                    GeometryReader { proxy in
                        ZStack(alignment: .topLeading) {
                            List {
                                ForEach(Array(sampleDates2.enumerated()), id: \.element ) { index, date2 in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.thinMaterial.opacity(0.8))
                                        .offset(x: hourTextWidth)
                                        .frame(width: proxy.size.width - hourTextWidth )
                                        .listRowInsets(EdgeInsets())
                                        .listRowBackground(Color.clear)
                                        .frame(height: proxy.size.height / 90 * CGFloat(date2.minute))
                                        .overlay(
                                            HStack {
                                                Text("00:00")
                                                    .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 14.0, weight: .regular)))
                                                    .opacity(0.8)
                                                    .padding(5)
                                            }
                                            ,alignment: .bottomLeading
                                        )
                                        .overlay(
                                            Rectangle()
                                                .fill(.gray)
                                                .frame(width: 300, height: 1)
                                                .opacity(0.8)
                                                .offset(x: 10)
                                            ,alignment: .bottomLeading
                                        )
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                print("delete action.")
                                                sampleDates2.remove(at: index)
                                            } label: {
                                                Image(systemName: "trash.fill")
                                            }
                                        }
                                        .overlay(
                                            Text("\(date2.name)")
                                                .font(.body)
                                                .fontWeight(.medium)
                                                .offset(x: hourTextWidth)
                                                .padding()
                                            ,alignment: .topLeading
                                        )
                                    
                                }
                            }
                            .listStyle(.plain)
                            //                        .border(.red, width: 5)
                            
                            .overlay(
                                VStack(alignment: .leading, spacing: 0){
                                    HStack {
                                        Text("00:00")
                                            .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 16.0, weight: .regular)))
                                            .overlay(
                                                /// Get the width of the 00:00 part.
                                                GeometryReader { proxy in
                                                    Color.clear
                                                        .onAppear{
                                                            hourTextWidth = proxy.size.width
                                                            hourTextHeight = proxy.size.height
                                                        }
                                                }
                                            )
                                        Rectangle().frame(height: 1)
                                    }.offset(y:-10)

                                    Spacer()

                                    HStack {
                                        Text("00:00")
                                            .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 16.0, weight: .regular)))
                                        Rectangle().frame(height: 1)
                                    }.offset(y: 10)
                                }
                            )
                            
                            
                        }
                    }
                    .padding()
                    .frame(width: 350, height: 500)
                }
            )
        
    }
}

struct ListTETS_Previews: PreviewProvider {
    static var previews: some View {
        ListTETS()
    }
}
