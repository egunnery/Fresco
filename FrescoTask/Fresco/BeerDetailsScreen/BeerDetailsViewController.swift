//
//  BeerDetailsViewController.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxGesture

class BeerDetailsViewController: UIViewController {
    
    /// The view model for the view
    private let beerDetailsViewModel: BeerDetailsViewModel
    
    /// The container UIView for the child views
    private let containerView: UIView
    
    /// The scroll view for allowing the view controller to scroll
    private let scrollView: UIScrollView
    
    /// The stack view containing the beer details
    private let stackView: UIStackView
    
    /// The image view containing the image of the beer
    private let beerImageView: UIImageView
    
    /// The label to display the beer strength
    private let abvLabel: UILabel
    
    /// The label containing the beer description
    private let descriptionLabel: UILabel
    
    /// The label containing the title for the malt ingredients
    private let maltLabel: UILabel
    
    /// The label containing the title for the hop ingredients
    private let hopLabel: UILabel
    
    /// The dispose bag for the instance's disposables
    private let disposeBag = DisposeBag()
    
    /// The initialiser for the view controller
    ///
    /// - Parameter beerDetailsViewModel: The view model for the view controller
    init(beerDetailsViewModel: BeerDetailsViewModel) {
        self.beerDetailsViewModel = beerDetailsViewModel
        self.containerView = UIView(frame: .zero)
        self.scrollView = UIScrollView(frame: .zero)
        self.stackView = UIStackView(frame: .zero)
        self.beerImageView = UIImageView(image: UIImage(imageURL: beerDetailsViewModel.beer.imageURL))
        self.abvLabel = UILabel(frame: .zero)
        self.descriptionLabel = UILabel(frame: .zero)
        self.maltLabel = UILabel(frame: .zero)
        self.hopLabel = UILabel(frame: .zero)
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
    }
    
    /// Method to set up the UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(containerView)
        containerView.addSubview(scrollView)
        self.title = beerDetailsViewModel.beer.name
        navigationController?.navigationBar.prefersLargeTitles = true
        scrollView.addSubview(stackView)
        scrollView.isScrollEnabled = true
        scrollView.addSubview(abvLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(beerImageView)
        beerImageView.contentMode = .scaleAspectFit
        descriptionLabel.numberOfLines = 0
        setupStackView()
    }
    
    /// Method to set up the stack view
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution  = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        
        for subview in stackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        stackView.addArrangedSubview(maltLabel)
        for malt in beerDetailsViewModel.beer.ingredients.malt {
            let maltView = IngredientView(ingredient: malt)
            stackView.addArrangedSubview(maltView)
        }
        stackView.addArrangedSubview(hopLabel)
        for hop in beerDetailsViewModel.beer.ingredients.hops {
            let hopView = IngredientView(ingredient: hop)
            stackView.addArrangedSubview(hopView)
        }
    }
    
    /// Method to set up the constraints
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.bottom.greaterThanOrEqualToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview()
        }
        beerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalTo(200)
        }
        abvLabel.snp.makeConstraints { make in
            make.top.equalTo(beerImageView.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(abvLabel.snp.bottom).offset(10)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).inset(20)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        for view in stackView.arrangedSubviews {
            view.snp.makeConstraints { make in
                make.width.equalTo(descriptionLabel.snp.width)
                make.leading.trailing.equalToSuperview()
            }
        }
    }
    
    /// Method to bind the view model
    private func bindViewModel() {
        beerDetailsViewModel.descriptionText
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        beerDetailsViewModel
            .abvText.drive(abvLabel.rx.boldText)
            .disposed(by: disposeBag)
        
        beerDetailsViewModel.hopTitle
            .drive(hopLabel.rx.boldText)
            .disposed(by: disposeBag)
        
        beerDetailsViewModel.maltTitle
            .drive(maltLabel.rx.boldText)
            .disposed(by: disposeBag)
        
        for view in stackView.arrangedSubviews {
            view.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self ] element in
                    if let element = element.view as? IngredientView {
                        self?.beerDetailsViewModel.goToWeighScreen(ingredient: element.ingredient)
                    }
                }).disposed(by: disposeBag)
        }
    }
}
