//
//  Coordinator.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import UIKit
import RxSwift

class Coordinator {

    private let window: UIWindow?
    
    /// Holds the `UINavigationController` to use for presenting the flow
    private let navigationController: UINavigationController?

    init(window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }

    /// Method to start the app with
    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        showBrowserView()
    }

    /// Method to navigate to the browser view
    func showBrowserView() {
        let beerAPI = BeerAPI()
        let vm = BrowserViewModel(api: beerAPI, coordinator: self)
        let vc = BrowserViewController(browserViewModel: vm)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    /// Method to navigate to the beer details view
    ///
    /// - Parameter beer: The beer for the view
    func showBeerDetails(for beer: Beer) {
        let vm = BeerDetailsViewModel(beer: beer, coordinator: self)
        let vc = BeerDetailsViewController(beerDetailsViewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Method to navigate to the weighing screen
    ///
    /// - Parameter ingredient: The ingredient to weigh
    func showWeighScreen(for ingredient: Ingredient) {
        let vm = WeighViewModel(ingredient: ingredient, coordinator: self)
        let vc = WeighViewController(weighViewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Method to navigate back to the previous screen
    ///
    /// - Parameter navigationController: The navigation controller to pop
    func navgateBack(viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
}
