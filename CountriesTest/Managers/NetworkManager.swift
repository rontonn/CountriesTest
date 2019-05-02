//
//  NetworkManager.swift
//  CountriesTest
//
//  Created by Anton Romanov on 30/04/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

class NetworkManager {
    
    // MARK: - Public methods
    static func getCountriesData(fromUrl url: String) -> Observable<[Country]>{
        return json(.get, url)
            .map(parseCountriesInfo)
    }
    
    // MARK: - Private methods
    private static func parseCountriesInfo(fromRawData json: Any) -> [Country] {

        guard let items = json as? [[String : Any]] else {
            fatalError("There is error in parsing countries raw data.")
        }
        
        var countries = [Country]()
        
        items.forEach { dict in
            guard let cId = dict["Id"] as? String,
                    let cName = dict["Name"] as? String,
                    let cTime = dict["Time"] as? String,
                    let cImage = dict["Image"] as? String? else {
                return
            }
            
            countries.append(Country(withId: cId, name: cName, time: cTime, image: cImage))
        }
        
        return countries
    }
}
