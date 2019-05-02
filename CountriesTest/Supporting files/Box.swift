//
//  Box.swift
//  CountriesTest
//
//  Created by Anton Romanov on 30/04/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
