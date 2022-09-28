//
//  LoaderViewController.swift
//  Flickr
//
//  Created by David Castro Cisneros on 30/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit

/// A Loader to present while is getting fetch, since the service is usually very fast, an interval can be set to improve the UX
final class LoaderViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var isAskedToClose = false
    var hasBeenShownForMinimumTime = false
    lazy var minimumTimer = Timer()
    let minimumTime: TimeInterval = 0.1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .darkGray
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        minimumTimer = Timer.scheduledTimer(timeInterval: minimumTime, target: self, selector: #selector(finishMinimumTime), userInfo: nil, repeats: true)
    }
    
    @objc func finishMinimumTime() {
        minimumTimer.invalidate()
        hasBeenShownForMinimumTime = true
        removeIfPossible()
    }
    
    func removeIfPossible() {
        guard isAskedToClose, hasBeenShownForMinimumTime else { return }
        view.alpha = 1
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.alpha = 0.25
        } completion: { [weak self] completed in
            self?.dettachFromParent()
            self?.removeFromParent()
        }
    }
    
    func dettachFromParent() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
    }
}

extension UIViewController {
    func showLoader(enableMinimumTime: Bool = false) {
        DispatchQueue.main.async { [unowned self] in
            let child = LoaderViewController()
            child.hasBeenShownForMinimumTime = !enableMinimumTime
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
            
            child.view.alpha = 0.5
            UIView.animate(withDuration: 0.25) {
                child.view.alpha = 1
            }
        }
    }
    
    func dismissLoader() {
        DispatchQueue.main.async { [unowned self] in
            guard let child = self.children.last as? LoaderViewController else { return }
            child.isAskedToClose = true
            child.removeIfPossible()
        }
    }
}
