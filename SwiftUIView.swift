//
//  SwiftUIView.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/02.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var showingSecondView = false
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(0..<24, id: \.self) { hour in
                    Text("\(hour)")
                        .frame(width: 350, height: 50)
                        .onTapGesture {
                            showingSecondView = true
                        }
                }
            }
            .navigationDestination(isPresented: $showingSecondView) {
                Text("Hello")
            }
        }
    }
}

struct SecondView: View {
    var body: some View {
        Text("TEST")
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
