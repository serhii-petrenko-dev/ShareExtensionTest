//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Serhii on 09.10.2025.
//

import UIKit
import SwiftUI
 
class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Set the root view to semi-transparent black (80% opacity)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
 
        // Container view that represents the half-sheet card with solid background
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 30.0/255.0, alpha: 1.0) // #1C1C1E
        view.addSubview(containerView)
 
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
}
