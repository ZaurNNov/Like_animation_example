//
//  ViewController.swift
//  Like_animation
//
//  Created by Zaur Giyasov on 10/09/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let bgImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "fb_core_data_bg"))
        return imageView
    }()
    
    let iconsContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        let padding: CGFloat = 5
        let iconHeight: CGFloat = 35
        
        // stack view and subviews
        let images = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "angry")]
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = iconHeight / 2
            
            return imageView
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        container.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubviews.count)
        let width = numIcons * iconHeight + (numIcons + 1) * padding
        
        container.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        container.layer.cornerRadius = container.frame.height / 2
        
        // shadow
        container.layer.shadowColor = UIColor.darkGray.cgColor
        container.layer.shadowRadius = 8
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: 3, height: 4)
        
        stackView.frame = container.frame
        
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(bgImageView)
        bgImageView.frame = view.frame
        
        setupLongPressGesture()
        
    }
    
    fileprivate func setupLongPressGesture() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            self.handleGestureBegan(gesture: gesture)
            
        } else if gesture.state == .ended {
            self.handleGestureEnded(gesture: gesture)
        
        } else if gesture.state == .changed {
            self.handleGestureChanged(gesture: gesture)
        }
    }
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconsContainerView)
        // let hitTestView = iconsContainerView.hitTest(pressedLocation, with: nil)
        
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconsContainerView.frame.height / 2)
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
    }
    
    fileprivate func handleGestureEnded(gesture: UILongPressGestureRecognizer) {
        // clean up the aninmation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .transitionCurlUp, animations: {
            
            let stackView = self.iconsContainerView.subviews.first
            stackView?.subviews.forEach({ (imageView) in
                imageView.transform = .identity
            })
            
            self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 50)
            self.iconsContainerView.alpha = 0
            
        }) { (_) in
            self.iconsContainerView.removeFromSuperview()
        }

    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconsContainerView)
        
        let pressedLocation = gesture.location(in: self.view)
        
        // transform red box
        let centerX = (view.frame.width - iconsContainerView.frame.width) / 2
        
        // alpha
        iconsContainerView.alpha = 0
        self.iconsContainerView.transform = CGAffineTransform(translationX: centerX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .transitionCurlUp, animations: {
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: centerX, y: pressedLocation.y - self.iconsContainerView.frame.height)
        })
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

