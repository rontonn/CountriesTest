//
//  MainTableViewController.swift
//  CountriesTest
//
//  Created by Anton Romanov on 30/04/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift
import RxCocoa
import RxDataSources

let imageCache = AutoPurgingImageCache(
    memoryCapacity: 100_000_000,
    preferredMemoryUsageAfterPurge: 60_000_000
)

class MainTableViewController: UITableViewController {
    
    // MARK: - Properties
    var dataSource: RxTableViewSectionedAnimatedDataSource<SectionOfCountries>!
    let mainTableViewModel = MainTableViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = createDataSource()
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: UIControlEvents.valueChanged)
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rowHeight = 60.0
        
        setUpTableWithCountries()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }
    
    // MARK: - Public methods
    @objc func refreshTable() {
        mainTableViewModel.getCountriesData()
        refreshControl?.endRefreshing()
    }
    
    func setUpTableWithCountries() {
        DispatchQueue.main.async { [unowned self] in
            self.mainTableViewModel.countries.asObservable()
                .map { countries in [SectionOfCountries(header: "Countries", items: countries)] }
                .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
                .disposed(by: self.disposeBag)
        }

        tableView.rx.itemDeleted
            .subscribe(onNext: { [unowned self] indexPath in
                self.mainTableViewModel.removeCountry(at: indexPath)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func createDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionOfCountries> {
        
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .left),
            configureCell:{ (ds, tableView, indexPath, element) -> UITableViewCell in
    
                let cell = tableView.dequeueReusableCell(withIdentifier:
                    "countryCell", for: indexPath) as! MainTableViewCell
                
                cell.countryName.text = element.name
                if let imageUrl = element.image {
                    
                    if let image = imageCache.image(withIdentifier: element.id) {
                        cell.countryImageView.image = image
                        
                    } else {
                        cell.countryImageView.af_setImage(withURL: URL(string: imageUrl)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.global(qos: .background), imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: { response in
                            
                            if let imageData = response.data, let image = UIImage(data: imageData) {
                                
                                if let requestedImageURL = response.request?.url {
                                    if requestedImageURL.absoluteString == element.image {
                                        imageCache.add(image, withIdentifier: element.id)
                                    }
                                }
                            }
                        })
                    }
                }
                
                return cell
        },
            canEditRowAtIndexPath: { _, _ in true }
        )
    }
    
}

