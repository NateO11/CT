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
}

let schools = [
    School(name: "Virginia", imageName: "UVA"),
    School(name: "James Madison", imageName: "JMU"),
    School(name: "George Mason", imageName: "GMU"),
    School(name: "Washington and Lee", imageName: "WandL"),
    School(name: "Virginia fuck faces", imageName: "VT")
]
