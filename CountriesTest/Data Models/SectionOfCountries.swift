//
//  SectionOfCountries.swift
//  CountriesTest
//
//  Created by Anton Romanov on 02/05/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfCountries {
    var header: String?
    var items: [Country]
}

extension SectionOfCountries: AnimatableSectionModelType {
    typealias Item = Country
    
    var identity: String { return self.header ?? "SectionOfCountries" }
    
    init(original: SectionOfCountries, items: [Country]) {
        self = original
        self.items = items
    }
}
