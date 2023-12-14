//
//  Reviews.swift
//  CT
//
//  Created by Griffin Harrison on 12/10/23.
//

import SwiftUI

struct Reviews: View {
    
    @State private var switchview: Bool = false

    
    var body: some View {
        NavigationView {
                    VStack {
                        NavigationLink(destination: LoginPage()) {
                            Text("Login")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
    }
}

struct Reviews_Previews: PreviewProvider {
    static var previews: some View {
        Reviews()
    }
}
