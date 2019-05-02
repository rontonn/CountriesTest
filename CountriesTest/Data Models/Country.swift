//
//  Country.swift
//  CountriesTest
//
//  Created by Anton Romanov on 01/05/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation
import RxDataSources

struct Country {
    // MARK: - Properties
    let id: String
    let time: String
    let name: String
    let image: String?
    
    
    // MARK: - Lifecycle
    init(withId id: String, name: String, time: String, image: String? = nil) {
        self.id = id
        self.name = name
        self.time = time
        self.image = image
    }
}

extension Country: IdentifiableType, Equatable {
    
    static func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.id == rhs.id
    }
    
    var identity: String {
        return id
    }
}

