//
//  WeighViewController.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import UIKit
import RxSwift

class WeighViewController: UIViewController {
    
    /// The view model for the view
    private let weighViewModel: WeighViewModel
    
    /// The progress view for the bluetooth scale
    private var circularProgressBarView: CircularProgressBarView
    
    /// The label to display each new weight event value
    private let receivedWeightLabel: UILabel
    
    /// The label to display the target weight for the ingredient
    private let targetWeightLabel: UILabel
    
    /// The button to trigger finishing weighing
    private let doneButton: UIButton
    
    /// The dispose bag for the instance's disposables
    private let disposeBag = DisposeBag()
    
    /// The initialiser for the view controller
    ///
    /// - Parameter weighViewModel: The view model for the view controller
    init(weighViewModel: WeighViewModel) {
        self.weighViewModel = weighViewModel
        self.circularProgressBarView = CircularProgressBarView(frame: .zero)
        self.receivedWeightLabel = UILabel()
        self.targetWeightLabel = UILabel()
        self.doneButton = UIButton(frame: .zero)
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
    func setupUI() {
        view.backgroundColor = .white
        title = weighViewModel.ingredient.name
        view.addSubview(circularProgressBarView)
        view.addSubview(receivedWeightLabel)
        view.addSubview(targetWeightLabel)
        view.addSubview(doneButton)
        circularProgressBarView.center = view.center
        receivedWeightLabel.textAlignment = .center
        targetWeightLabel.textAlignment = .center
        doneButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        doneButton.layer.cornerRadius = 25
    }
    
    /// Method to setup constraints
    func setupConstraints() {
        circularProgressBarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        receivedWeightLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(75)
            make.width.equalTo(150)
        }
        targetWeightLabel.snp.makeConstraints { make in
            make.top.equalTo(receivedWeightLabel.snp.bottom)
            make.leading.equalTo(receivedWeightLabel.snp.leading)
            make.trailing.equalTo(receivedWeightLabel.snp.trailing)
            make.height.equalTo(30)
        }
        doneButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(50)
            make.leading.equalToSuperview().offset(50)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
    
    /// Method to bind the view model
    func bindViewModel() {
        weighViewModel.targetWeightText
            .drive(targetWeightLabel.rx.text)
            .disposed(by: disposeBag)
        
        weighViewModel.doneButtonTitle
            .drive(doneButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        var baseTimeStamp = 0
        var oldWeight = 0.0
        
        weighViewModel.weightEvent.emit(onNext: { [weak self] weightEvent in
            if let weightEvent = weightEvent {
                if baseTimeStamp < weightEvent.timestamp {
                    let newWeight = Double(Double(weightEvent.weight) / 10000.0)
                    
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 40, weight: .bold),
                        .foregroundColor: UIColor.black
                    ]
                    let attrString = NSAttributedString(string: "\(newWeight)", attributes: attributes)
                    self?.receivedWeightLabel.attributedText = attrString
                    
                    guard let ingredientValue = self?.weighViewModel.ingredient.amount.value else {
                        return
                    }
                    let weightAsAPercentageOfFullBar = newWeight / ingredientValue
                    self?.circularProgressBarView.progressAnimation(duration: 1.0,
                                                                    toValue: weightAsAPercentageOfFullBar,
                                                                    fromValue: oldWeight)
                    if weightAsAPercentageOfFullBar > 1 {
                        self?.circularProgressBarView.progressLayer.strokeColor = UIColor.red.cgColor
                    }
                    baseTimeStamp = weightEvent.timestamp
                    oldWeight = weightAsAPercentageOfFullBar
                }
            }
        })
        .disposed(by: disposeBag)
        
        doneButton.rx.tap.bind(onNext: {
            self.weighViewModel.navigateBackToDetailsScreen(viewController: self)
        }).disposed(by: disposeBag)
    }
}
