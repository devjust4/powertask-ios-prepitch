//
//  ProgressCircleSessions.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 9/3/22.
//

import SwiftUI
import Combine

let defaultTimeRemaining: CGFloat = 30
let lineWith: CGFloat = 20
let radius: CGFloat = 80

struct ContentView: View {
    @State private var isActive = false
    @State private var timeRemaining: CGFloat = defaultTimeRemaining
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 25) {
            ZStack {
                Circle()
                    .stroke(Color.green, style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                Circle()
                    .trim(from: 0, to: 1 - ((defaultTimeRemaining - timeRemaining) / defaultTimeRemaining))
                    .stroke(timeRemaining > 6 ? Color.gray.opacity(0.2) : timeRemaining > 3 ? Color.yellow : Color.red, style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut)
                Text("\(Int(timeRemaining))").font(.largeTitle)
            }.frame(width: radius * 4, height: radius * 4)
        }.onReceive(timer, perform: { _ in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isActive = false
                timeRemaining = defaultTimeRemaining
            }
        })
        
        
    }
}

class ContentView_Previews: ObservableObject {
    @Published var text: String

    init(text: String) {
        self.text = text
    }
}
