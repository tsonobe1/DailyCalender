//
//  TaskDetailTitle.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/12.
//

import SwiftUI

struct TaskDetailTitleView: View {
    @EnvironmentObject var timeBoxState: TimeBoxState
    @Binding var title: String
    
    var body: some View {
        Text("\(title)")
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .gesture(
                TapGesture()
                    .onEnded{
                        timeBoxState.isNavigation = false
                    }
            )
    }
}

struct TaskDetailTitle_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailTitleView(title: .constant("TEST TASK"))
    }
}
