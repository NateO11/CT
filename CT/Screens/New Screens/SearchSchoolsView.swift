//
//  SearchSchoolsView.swift
//  CT
//
//  Created by Nate Owen on 3/7/24.
//

import SwiftUI

struct SearchSchoolsView: View {
    @ObservedObject var viewModel : ExploreViewModel
    
    var body: some View {
        List{
            Text("School A")
            Text("School B")
            Text("School C")
        }
    }
}

#Preview {
    SearchSchoolsView(viewModel: ExploreViewModel())
}
