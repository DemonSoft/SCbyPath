//
//  ContentView.swift
//  SplittableCoordinator
//
//  Created by Dmitriy Soloshenko on 19.03.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var model = Coordinator
    var body: some View {
        ZStack {
            NavigationStack(path: $model.path) {
                
                
                DummyView("Select screen", .white)

                Group {}
                    .navigationDestination(for: CoordinatorService.Step.self) { destination in
                        destination.view
                            
                    }
                    
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
