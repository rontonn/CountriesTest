//
//  MainTableViewCell.swift
//  CountriesTest
//
//  Created by Anton Romanov on 01/05/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countryImageView.af_cancelImageRequest()
        countryImageView.image = nil
    }
}
