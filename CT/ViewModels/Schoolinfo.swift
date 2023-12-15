//
//  Schoolinfo.swift
//  CT
//
//  Created by Nate Owen on 12/14/23.
//

import Foundation

struct School: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var imageName: String
    var location: String
    var yearFounded: Int
}

let schools = [
    School(name: "University of Virginia", imageName: "UVA", location: "Charlottesville, VA", yearFounded: 1819),
    School(name: "James Madison University", imageName: "JMU", location: "Harrisonburg, VA", yearFounded: 1908),
    School(name: "George Mason University", imageName: "GMU", location: "Fairfax, VA", yearFounded: 1949),
    School(name: "Washington and Lee University", imageName: "WandL", location: "Lexington, VA", yearFounded: 1749),
    School(name: "Virginia Tech", imageName: "VT", location: "Blacksburg, VA", yearFounded: 1872)
]



