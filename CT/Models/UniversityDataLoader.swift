//
//  UniversityDataLoader.swift
//  CT
//
//  Created by Nate Owen on 12/11/23.
//

import Foundation

class UniversityDataLoader {
    static func loadUniversityData() -> University? {
        do {
            guard let url = Bundle.main.url(forResource: "uva_info", withExtension: "json"),
                  let jsonString = try? String(contentsOf: url, encoding: .utf8),
                  let data = jsonString.data(using: .utf8) else {
                throw NSError(domain: "Data Loading", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load data from JSON file."])
            }
            
            let university = try JSONDecoder().decode(University.self, from: data)
            return university
        } catch {
            print("Error loading UVA data:", error.localizedDescription)
            return nil
        }
    }
}

