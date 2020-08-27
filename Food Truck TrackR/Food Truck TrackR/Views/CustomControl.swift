//
//  CustomControl.swift
//  Food Truck TrackR
//
//  Created by Juan M Mariscal on 8/24/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomControl: UIControl {
    
    // MARK: - Properties
    var value: Int = 1
    private let componentDimension: CGFloat = 40.0
    private let componentCount: CGFloat = 5.0
    private let componentActiveColor: UIColor = .black
    private let componentInactiveColor: UIColor = .gray
    private var starArray: [UILabel] = []
    var label = UILabel()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
    }
    
    // MARK: - Functions
    private func setUpSubviews() {
        
        backgroundColor = .clear
        
        for _ in 1...5 {
            let label = UILabel()
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false

            
            label.font = .boldSystemFont(ofSize: 32.0)
            label.text = "☆"
            label.textAlignment = .center
            starArray.append(label)
            
            
        }
        
        if label.tag == 1 {
            label.textColor = componentActiveColor
        } else {
            label.textColor = componentInactiveColor
        }
        
        let stackView = UIStackView(arrangedSubviews: starArray)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.isUserInteractionEnabled = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8

        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
    let componentsWidth = CGFloat(componentCount) * componentDimension
    let componentsSpacing = CGFloat(componentCount + 1) * 8.0
    let width = componentsWidth + componentsSpacing
    return CGSize(width: width, height: componentDimension)
}

}

extension CustomControl {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        updateValue(at: touch)
        sendActions(for: [.touchDown, .valueChanged])
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let touchPoint = touch.location(in: self)
        
        if bounds.contains(touchPoint) {
            sendActions(for: [.valueChanged, .touchDragInside, .touchDragOutside])
            updateValue(at: touch)
        } else {
            sendActions(for: .touchDragOutside)
        }
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        defer {
            super.endTracking(touch, with: event)
        }
        
        guard let touch = touch else { return }
        let touchPoint = touch.location(in: self)
        
        if bounds.contains(touchPoint) {
            updateValue(at: touch)
            sendActions(for: [.valueChanged, .touchUpInside, .touchUpOutside])
        } else {
            sendActions(for: .touchUpOutside)
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: .touchCancel)
        super.cancelTracking(with: event)
    }
    
    func updateValue(at touch: UITouch) {
        for label in starArray {
            if touch.location(in: self).x >= label.frame.minX {
                value = label.tag
                label.textColor = componentActiveColor
                label.performFlare()
            } else {
                label.textColor = componentInactiveColor
            }
        }
    }
    
}

extension UIView {
  func performFlare() {
    func flare()  { transform = CGAffineTransform(scaleX: 1.6, y: 1.6) }
    func unflare() { transform = .identity }
    UIView.animate(withDuration: 0.3,
            animations: { flare() },
            completion: { _ in UIView.animate(withDuration: 0.1) { unflare() }})
  }
}
