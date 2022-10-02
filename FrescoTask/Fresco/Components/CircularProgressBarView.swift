//
//  CircularProgressBarView.swift
//  Fresco
//
//  Created by Eoin Gunnery on 01/10/2022.
//

import UIKit
import SnapKit
import RxSwift

public class CircularProgressBarView: UIView {
    
    /// The point to begin the arc
    private var startPoint = CGFloat(-Double.pi - 0.5)
    
    /// The point to end the arc
    private var endPoint = CGFloat(0.5)
    
    /// The full amount layer
    private var circleLayer = CAShapeLayer()
    
    /// The progressable layer
    var progressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Method to setup the UI
    private func setupUI() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 120, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 5.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.lightGray.cgColor
        layer.addSublayer(circleLayer)
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 5.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.green.cgColor
        layer.addSublayer(progressLayer)
    }
    
    /// Method to move the progress layer through the circle layer
    ///
    /// - Parameters:
    ///   - duration: How long the progress takes to complete
    ///   - toValue: The end point of the progress layer
    ///   - fromValue: The beginning point of the progress layer
    func progressAnimation(duration: TimeInterval, toValue: Double, fromValue: Double) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.fromValue = fromValue
        circularProgressAnimation.toValue = toValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
