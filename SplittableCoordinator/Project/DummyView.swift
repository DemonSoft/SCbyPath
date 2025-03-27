//
//  DummyView.swift
//  SplittableCoordinator
//
//  Created by Dmitriy Soloshenko on 19.03.2025.
//

import SwiftUI

struct DummyView: View {
    var title: String
    var color: Color
  
    init(_ title: String, _ color: Color) {
        self.title = title
        self.color = color
    }
    
    var body: some View {
        VStack {
            Text(self.title)
                .foregroundStyle(.black)
                .font(.title)
            
            VStack(spacing: 24) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                Button("Auth a") { Coordinator.next(.auth(.a)) }
                Button("Auth b") { Coordinator.next(.auth(.b)) }
                Button("Auth c") { Coordinator.next(.auth(.c)) }
                Button("Profile a") { Coordinator.next(.profile(.a)) }
                Button("Profile b") { Coordinator.next(.profile(.b)) }
                Button("Profile c") { Coordinator.next(.profile(.c)) }
                Button("Root") { Coordinator.root() }
                Button("Keep current path") { Coordinator.keepPath() }
                Button("Pass by kept path") { Coordinator.setPath(Coordinator.memoryPath) }

            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 0).fill(self.color).opacity(0.25)
        )
        .background(.white)
        .ignoresSafeArea()
        
    }
}

#Preview {
    DummyView("Preview", .white)
}
