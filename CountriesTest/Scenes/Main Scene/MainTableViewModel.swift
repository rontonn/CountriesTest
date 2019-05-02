//
//  MainTableViewModel.swift
//  CountriesTest
//
//  Created by Anton Romanov on 30/04/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias CountrySection = AnimatableSectionModel<String, Country>

class MainTableViewModel {
    // MARK: - Properties
    private let url = "https://raw.githubusercontent.com/Softex-Group/task-mobile/master/test.json"
    private var disposeBag = DisposeBag()
    
    var countries = BehaviorRelay<[Country]>(value: [])
    
    // MARK: - Lifecycle
    init() {
        getCountriesData()
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    // MARK: - Public methods
    func removeCountry(at index: IndexPath) {
        var tempArray = countries.value
        tempArray.remove(at: index.row)
        countries.accept(tempArray)
    }
    
    // MARK: - Private methods
    func getCountriesData() {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            NetworkManager.getCountriesData(fromUrl: self.url).bind(to: self.countries)
                .disposed(by: self.disposeBag)
        }

    }
}
