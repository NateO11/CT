//
//  AuthState.swift
//  CT
//
//  Created by Nate Owen on 1/3/24.
//

import SwiftUI
import Combine

class AuthState: ObservableObject {
    @Published var signedIn: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        // If you are updating signedIn from a background thread,
        // use receive(on: DispatchQueue.main) to switch to the main thread.
        $signedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
}
