//
//  CoordinatorService.swift
//  SplittableCoordinator
//
//  Created by Dmitriy Soloshenko on 19.03.2025.
//

import SwiftUI

let Coordinator = CoordinatorService()

class CoordinatorService: ObservableObject {
    

    enum Step: Hashable {
        enum Segment: String {
            case auth
            case profile
        }

        case auth(_ val: CoordinatorAuth)
        case profile(_ val: CoordinatorProfile)
        
        var screen: (String, String) {
            switch self {
                case .auth(let screen): return (Segment.auth.rawValue, screen.rawValue)
                case .profile(let screen): return (Segment.profile.rawValue, screen.rawValue)
            }
        }

        var view: some View {
            Group {
                switch self {
                    case .auth(let value): value.view
                    case .profile(let value): value.view
                }
            }
        }
    }
    

    @Published var path: [Step] = []
    
    private (set) var memoryPath = ""
    
    private var currentSegment: Step.Segment?
    
    func next(_ step: Step) {
        Task {
            await MainActor.run {
                withAnimation {
                    self.path += [step]
                }
            }
        }
    }
    
    func root() {
        Task {
            await MainActor.run {
                withAnimation {
                    self.path = []
                }
            }
        }
    }
    
    func keepPath() {
        self.memoryPath = self.buildPath()
        self.root()
    }

    func setPath(_ path: String) {
        self.currentSegment = nil
        let array = path.components(separatedBy: "/")
        self.handlePath(array)
    }
    
    // MARK: - Private
    private func handlePath(_ array:[String]) {
        guard array.count > 0 else { return }
        var array = array
        let step = array.removeFirst()
        self.handleStep(step)
        self.handlePath(array) // Recursive call
    }
    
    
    private func handleStep(_ step: String) {
        switch step {
            case "": self.root()                 // if path starts with '/'
            case Step.Segment.auth.rawValue,     // if path has coordinator
            Step.Segment.profile.rawValue:
            self.currentSegment = Step.Segment(rawValue: step)

            default: self.handleCoordinator(step)
        }
    }

    private func handleCoordinator(_ step: String) {
        
        guard let segment = self.currentSegment else { return }
        
        switch segment {
            case .auth: 
                if let c = CoordinatorAuth(rawValue: step) {
                    self.next(.auth(c))
                }
            
            case .profile:
                if let c = CoordinatorProfile(rawValue: step) {
                    self.next(.profile(c))
                }
        }
    }
    
    func buildPath() -> String {
        var fullPath = ""
        var segment = ""
        
        for step in self.path {
            
            let (seg, screen) = step.screen
            
            if segment != seg {
                segment = seg
                fullPath += "/\(seg)"
            }

            fullPath += "/\(screen)"
        }
        
        return fullPath
    }
}
