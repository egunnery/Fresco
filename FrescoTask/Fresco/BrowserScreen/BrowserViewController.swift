//
//  BrowserViewController.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class BrowserViewController: UIViewController, UITableViewDelegate {

    /// The view model for the view
    private let browserViewModel: BrowserViewModel
    
    /// The Table View to display beers
    private var tableView: UITableView
    
    /// The dispose bag for the instance's disposables
    private let disposeBag = DisposeBag()
    
    /// The initialiser for the view controller
    ///
    /// - Parameter browserViewModel: The view model for the view controller
    init(browserViewModel: BrowserViewModel) {
        self.browserViewModel = browserViewModel
        self.tableView = UITableView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Method called when the view has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindViewModel()
        showLoadingIndicator()
    }
    
    /// Method to set up the UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        self.title = "Beers"
        tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: BeerTableViewCell.reuseIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Method to setup constraints
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(50)
        }
    }
    
    /// Method to bind the view model
    private func bindViewModel() {
        browserViewModel.getBeers().observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] beers in
                let tableViewItems = Observable.just(beers)
                self?.setupTableView(items: tableViewItems)
                self?.dismiss(animated: false)
            }, onFailure: { [weak self] error in
                //TODO: Add retry
                self?.dismiss(animated: false)
                let alertController = UIAlertController(title: "Network failure", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }
                    alertController.addAction(cancelAction)
                    self?.present(alertController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.browserViewModel.didTapCell(at: indexPath)
        })
        .disposed(by: disposeBag)
    }
    
    /// Method to set up the table view
    ///
    /// - Parameter items: The items to use for the table view
    private func setupTableView(items: Observable<[Beer]>) {
        items.bind(to: tableView.rx.items(cellIdentifier: BeerTableViewCell.reuseIdentifier, cellType: BeerTableViewCell.self)) { (row, beer, cell) in
            let beerCompact = BeerCompact(beerName: beer.name, beerImage: UIImage(imageURL: beer.imageURL)!, beerABV: beer.abv)
            cell.updateValues(beerCompact: beerCompact)
            cell.accessibilityIdentifier = "Cell"
            cell.textLabel?.numberOfLines = 0
        }
        .disposed(by: disposeBag)
    }
    
    /// Method to show a loading view while the network request is in progress.
    private func showLoadingIndicator() {
        let alert = UIAlertController(title: nil, message: "Pouring...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}
