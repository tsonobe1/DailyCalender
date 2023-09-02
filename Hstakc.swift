//
//  Hstakc.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/08.
//

import SwiftUI

struct Hstakc: View {
    var body: some View {
        List {
            HStack{
                Text("TESTTEST")
                    .minimumScaleFactor(0.1)
            }
            .frame(height: 10)
            .listRowInsets(EdgeInsets())
            
            HStack{
                Text("TESTTEST")
            }
            .listRowInsets(EdgeInsets())
            
            HStack{
                Text("TESTTEST")
            }
            .listRowInsets(EdgeInsets())
            
            HStack{
                Text("TESTTEST")
            }
            .listRowInsets(EdgeInsets())
            
            HStack{
                Text("TESTTEST")
            }
            .listRowInsets(EdgeInsets())
            
            HStack{
                Text("TESTTEST")
            }
            .listRowInsets(EdgeInsets())
            
            HStack{
                Text("TESTTEST")
            }
            .listRowInsets(EdgeInsets())
        }
        .environment(\.defaultMinListRowHeight, 0)
        .listStyle(.automatic)
    }
}

struct Hstakc_Previews: PreviewProvider {
    static var previews: some View {
        Hstakc()
    }
}
