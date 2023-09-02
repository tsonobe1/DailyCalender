//
//  LazyHGridTest.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/08.
//

import SwiftUI

struct sampleDate: Identifiable, Hashable {
    var name: String
    var minute: Int
    var id: UUID
}



struct LazyHGridTest: View {
    @State private var hourTextWidth = CGFloat.zero
    @State var sampleDates = [
        sampleDate(name: "TEST1", minute: 40, id: UUID()),
        sampleDate(name: "TEST2", minute: 60, id: UUID()),
        sampleDate(name: "TEST3", minute: 20, id: UUID())
    ]
    
    
    var body: some View {
        
        
        RoundedRectangle(cornerRadius: 10)
            .fill(.purple.gradient)
            .colorMultiply(Color(UIColor.systemGray))
            .ignoresSafeArea()
            .overlay(
                VStack{
                    Text("\(UUID())")
                        .font(.title)
                        .foregroundColor(.white)
//                                        Spacer()
                    
                    GeometryReader{ proxy in
                        VStack(spacing: 0){
                            ScrollView {
                                VStack(spacing: 0){
                                    Text("\(hourTextWidth)")
                                    ForEach(sampleDates) { date in
                                        // -------------------------------
                                        HStack {
                                            Text("18:00")
                                                .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 16.0, weight: .regular)))
                                                .overlay(
                                                    /// Get the width of the 00:00 part.
                                                    GeometryReader { textProxy in
                                                        Color.clear
                                                            .onAppear{
                                                                hourTextWidth = textProxy.size.width
                                                            }
                                                    }
                                                )
                                            Rectangle().frame(height: 1)
                                        }
                                        
                                        .foregroundColor(Color.secondary)
                                        .frame(height: proxy.size.height / 120 * CGFloat(date.minute),  alignment: .top)
                                        .overlay(
                                            
                                            List{
                                                // -------------------------------
                                                HStack{
                                                    Text("\(proxy.size.height / 120 * CGFloat(date.minute))")
                                                        .minimumScaleFactor(1)
                                                    Spacer()
                                                    Text("\(date.minute)")
                                                        .minimumScaleFactor(0.1)
                                                    Text(" min").font(.caption)
                                                        .minimumScaleFactor(0.1)
                                                }
//                                                .offset(x: hourTextWidth)
//                                                .frame(width: proxy.size.width - hourTextWidth)
                                            
                                   
                                                .frame(height: 5 * CGFloat(date.minute))
                                                .listRowInsets(EdgeInsets())
                                                .listRowBackground(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(Material.thin)
//                                                        .offset(x: hourTextWidth)
//                                                        .frame(width: proxy.size.width - hourTextWidth)
                                                )
                                                .swipeActions(edge: .trailing) {
                                                    Button(role: .destructive) {
                                                        print("delete action.")
                                                    } label: {
                                                        Image(systemName: "trash.fill")
                                                    }
                                                }
                                            }
                                                .offset(x: hourTextWidth)
                                                .frame(width: proxy.size.width - hourTextWidth)
                                                .environment(\.defaultMinListRowHeight, 0)
                                                .listStyle(.plain)
                                            
                                                .offset(y: 9.5)
                                                .opacity(0.7)
                                        )
                                    }
                                }
                            }
                            
                            
                            
                            .padding(5)
                        }
                        //                                                    .listRowInsets(EdgeInsets())
                        //                                                            .scrollContentBackground(.hidden)
                        
                        
                    }
                    .frame(height: 400)
                }
                
            )
    }
    
}

struct LazyHGridTest_Previews: PreviewProvider {
    static var previews: some View {
        LazyHGridTest()
    }
}
