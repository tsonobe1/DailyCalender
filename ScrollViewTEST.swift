//
//  ScrollViewTEST.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/09.
//

import SwiftUI

struct sampleDate3: Identifiable, Hashable {
    var name: String
    var minute: Int
    var id: UUID
}



func makeTask2() -> Task1{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = "2022-12-06"
    let date = dateFormatter.date(from: dateString)!
    let startDate = Calendar.current.date(byAdding: .minute, value: 600, to: date)!
    let endDate = Calendar.current.date(byAdding: .minute, value: 690, to: date)!
    
    let task = Task1(name: "Sed ut perspiciatis unde omnis iste natus", startDate: startDate, endDate: endDate, id: UUID(), color: .red)
    return task
}

struct ScrollViewTEST: View {
    @State var sampleDates3 = [
        sampleDate3(name: "dignissimos ducimus qui blanditiis praesentium", minute: 30, id: UUID()),
        sampleDate3(name: "qui blanditiis praesentium", minute: 15, id: UUID()),
        sampleDate3(name: "blanditiis praesentium", minute: 15, id: UUID()),
        sampleDate3(name: "accusamus et iusto odio ", minute: 10, id: UUID()),
        sampleDate3(name: "At vero eos  qui blanditiis praesentium", minute: 15, id: UUID()),
        sampleDate3(name: "dignissimos ducimus blanditiis praesentium", minute: 30, id: UUID())

    ]
    var task  = makeTask2()
    var allMinute: CGFloat {
        var minutes = 0
        for i in sampleDates3 {
            minutes += i.minute
        }
        return CGFloat(minutes)
    }
    @State private var hourTextWidth: CGFloat = 0
    @State private var hourTextHeight: CGFloat = 0
    @State private var dividerWidth: CGFloat = 0
    @State private var magnify: CGFloat = 5
    
    var body: some View {
        Rectangle()
            .fill(task.color.gradient)
            .colorMultiply(Color(UIColor.systemGray))
            .ignoresSafeArea()
            .overlay(
                //MARK: /
                
                VStack {
                    Text("\(hourTextWidth)")
                        Text("TEST")
                        .font(.title)
                        .fontWeight(.heavy)
                    
                   RoundedRectangle(cornerRadius: 10)
                        .fill(.thinMaterial)
                        .frame(height: 150)
                        .overlay(
                            VStack{
                                Text("\(task.name)")
                                Text("\(task.startDate)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 20)

                            }
                        )
                        .padding(.horizontal, 50)
                        
                    
                    ScrollView{
                        if !sampleDates3.isEmpty {
                            
                            //MARK: EACH TIMELINE
                            VStack(spacing: 0){
                                    ForEach(Array(sampleDates3.enumerated()), id: \.element ) { index, date3 in
                                        Group {
                                            HStack{
                                                // ⏱️ 00:00
                                                Text("10:\(index * 10) ")
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
                                            .opacity(index == 0 ? 0 : 1)
                                            // ⏱️ Width per hour
                                            .frame(height: magnify * CGFloat(date3.minute), alignment: .topLeading)
                                        }
                                }
                                
                            }
                            //MARK: TASK TIMELINE (START AND END)
                            .overlay(
                                VStack(spacing: 0){
                                    HStack {
                                        Text("\(dateTimeFormatter(date: task.startDate))")
                                            .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .heavy)))
                                            .foregroundColor(task.color.opacity(0.8))
                                        
                                        // ⏱️ Divider
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(task.color)
                                            .frame(height: 1.5)
                                            .cornerRadius(10)
                                    }
                                    Spacer()
                                    
                                    HStack {
                                        Text("\(dateTimeFormatter(date: task.endDate))")
                                            .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .heavy)))
                                            .foregroundColor(task.color.opacity(0.8))
                                        
                                        // ⏱️ Divider
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(task.color)
                                            .frame(height: 1.5)
                                            .cornerRadius(10)
                                    }
                                }
                                
//                                    .colorInvert()
                                    .brightness(0.8)
                                    .frame(height: magnify * (caluculateTimeInterval(startDate: task.startDate, endDate: task.endDate)) + (hourTextWidth / 2.4))
                                ,alignment: .topLeading
                            )
                            //MARK: EACH STEP
                            .overlay(
                                List {
                                    ForEach(Array(sampleDates3.enumerated()), id: \.element ) { index, date3 in
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
                                            .listRowBackground(Color.clear)
                                            .swipeActions(edge: .trailing) {
                                                Button(role: .destructive) {
                                                    print("delete action.")
                                                    sampleDates3.remove(at: index)
                                                } label: {
                                                    Image(systemName: "trash.fill")
                                                }
                                            }
                                            .offset(x: hourTextWidth + hourTextWidth / 2, y: 0)
                                            .frame(width: dividerWidth )
                                            .frame(height: magnify * CGFloat(date3.minute), alignment: .topLeading)
                                    }
                                }
                                    .environment(\.defaultMinListRowHeight, 0)
                                    .offset(y: hourTextHeight/2)
                                    .listStyle(.plain)
                                
                                ,alignment: .topLeading
                            )
                            
                        }else {
                            VStack(spacing: 0){
                                HStack {
                                    Text("\(dateTimeFormatter(date: task.startDate))")
                                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .heavy)))
                                        .foregroundColor(task.color.opacity(0.8))
                                    
                                    // ⏱️ Divider
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(task.color)
                                        .frame(height: 1.5)
                                        .cornerRadius(10)
                                }
                                Spacer()
                                
                                HStack {
                                    Text("\(dateTimeFormatter(date: task.endDate))")
                                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .heavy)))
                                        .foregroundColor(task.color.opacity(0.8))
                                    
                                    // ⏱️ Divider
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(task.color)
                                        .frame(height: 1.5)
                                        .cornerRadius(10)
                                }
                            }
                            
                            //                                .offset(y: offset)
                            .brightness(0.8)
                            .frame(height: magnify * (caluculateTimeInterval(startDate: task.startDate, endDate: task.endDate)) + (hourTextWidth / 2.4))
                        }
                    }
                    
                    .padding(5)
                    
                    RoundedRectangle(cornerRadius: 10)
                         .fill(.thinMaterial)
                         .frame(height: 50)
                }
                
                
                
            )
    }
}

struct ScrollViewTEST_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewTEST()
    }
}
