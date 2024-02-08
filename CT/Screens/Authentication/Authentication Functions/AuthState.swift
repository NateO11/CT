//
//  AuthState.swift
//  CT
//
//  Created by Nate Owen on 1/3/24.
//


// Combine is used here for Any Cancellable

import SwiftUI
import Combine


// Observable Object beacuse we need to be able to check for changes in the the AuthState class
class AuthState: ObservableObject {
    
    /*
     signedIn, currentUserEmail, currentUserId let us call variables created else where and update the observer when changes are made
     */
    
    @Published var signedIn: Bool = false
   
    
    // saves the current user email and user id when specifc functions are run ( validate user, create user) 
    @Published var currentUserEmail: String?
    @Published var currentUserId: String?
    
    
    
    // AnyCancellable allows us to break the connection between the other classes useing the signedIN var
    private var cancellables: Set<AnyCancellable> = []

    
   // initializer for  AuthState class. It sets up a Combine pipeline to observe changes to the signedIn property.
   // combine pipeline allows us to process the value of signed in over a eriod of time
    
    // If you are updating signedIn from a background thread,
    // use receive(on: DispatchQueue.main) to switch to the main thread.
    init() {
        //initialize signedin, the dollar sign means that when the value changes we exceute the code below
        $signedIn
        // receive on the main thread
            .receive(on: DispatchQueue.main)
        // notifies a change in the state of the object to subscribers of this var
            .sink { [weak self] _ in self?.objectWillChange.send() }
        // stored the value in our set called cancellables
            .store(in: &cancellables)
    }
}

