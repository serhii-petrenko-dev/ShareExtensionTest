//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Serhii on 09.10.2025.
//

import UIKit
import MobileCoreServices

class ShareViewController: UIViewController {

    // UI Elements
    private let containerView = UIView()
    private let handleBar = UIView()
    private let titleLabel = UILabel()
    private let statusImageView = UIImageView()
    private let messageLabel = UILabel()
    private let urlLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let actionButton = UIButton(type: .system)
    private let retryButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()

    private var currentUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleSharedContent()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        // Container view (half screen) - Dark background
        containerView.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0) // #1C1C1E
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Handle bar
        handleBar.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        handleBar.layer.cornerRadius = 2.5
        handleBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(handleBar)

        // Title
        titleLabel.text = "Share Extension Test"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Status image
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.tintColor = UIColor(red: 0.914, green: 0.271, blue: 0.376, alpha: 1.0) // #E94560
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.isHidden = true
        containerView.addSubview(statusImageView)

        // Activity indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 0.914, green: 0.271, blue: 0.376, alpha: 1.0) // #E94560
        containerView.addSubview(activityIndicator)

        // Message label
        messageLabel.text = "Processing..."
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)

        // URL label
        urlLabel.font = .systemFont(ofSize: 14)
        urlLabel.textAlignment = .center
        urlLabel.numberOfLines = 2
        urlLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(urlLabel)

        // Button stack view
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 12
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.isHidden = true
        containerView.addSubview(buttonStackView)

        // Retry button
        retryButton.setTitle("Try Again", for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        retryButton.backgroundColor = UIColor(red: 0.890, green: 0.145, blue: 0.318, alpha: 1.0) // #E32551
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 25
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)

        // Action button (Cancel/Done)
        actionButton.setTitle("Cancel", for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        actionButton.backgroundColor = .clear
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 25
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        // Setup constraints
        NSLayoutConstraint.activate([
            // Container
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            // Handle bar
            handleBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            handleBar.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            handleBar.widthAnchor.constraint(equalToConstant: 40),
            handleBar.heightAnchor.constraint(equalToConstant: 5),

            // Title
            titleLabel.topAnchor.constraint(equalTo: handleBar.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            // Status image
            statusImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            statusImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 60),
            statusImageView.heightAnchor.constraint(equalToConstant: 60),

            // Activity indicator (same position as status image)
            activityIndicator.centerXAnchor.constraint(equalTo: statusImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: statusImageView.centerYAnchor),

            // Message label
            messageLabel.topAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),

            // URL label
            urlLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            urlLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            urlLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),

            // Button stack
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func handleSharedContent() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            showError("Invalid Share", message: "Unable to process this share")
            return
        }

        let typeIdentifier = kUTTypeURL as String

        if itemProvider.hasItemConformingToTypeIdentifier(typeIdentifier) {
            itemProvider.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { [weak self] (item, error) in
                DispatchQueue.main.async {
                    if let url = item as? URL {
                        self?.processUrl(url.absoluteString)
                    } else if let text = item as? String {
                        self?.processUrl(text)
                    } else {
                        self?.showError("Invalid URL", message: "Please provide a valid URL")
                    }
                }
            }
        } else if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePlainText as String) {
            itemProvider.loadItem(forTypeIdentifier: kUTTypePlainText as String, options: nil) { [weak self] (item, error) in
                DispatchQueue.main.async {
                    if let text = item as? String {
                        self?.processUrl(text)
                    } else {
                        self?.showError("Invalid URL", message: "Please provide a valid URL")
                    }
                }
            }
        } else {
            showError("Invalid Share", message: "Unable to process this share")
        }
    }

    private func processUrl(_ urlString: String) {
        currentUrl = urlString
        urlLabel.text = urlString

        // Simulate processing
        activityIndicator.startAnimating()
        statusImageView.isHidden = true
        messageLabel.text = "Processing URL..."

        // Show Cancel button during processing
        buttonStackView.arrangedSubviews.forEach { buttonStackView.removeArrangedSubview($0) }
        buttonStackView.subviews.forEach { $0.removeFromSuperview() }
        buttonStackView.addArrangedSubview(actionButton)
        buttonStackView.isHidden = false

        actionButton.setTitle("Cancel", for: .normal)
        actionButton.backgroundColor = .clear
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor

        // Simulate success after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showSuccess("URL processed successfully!")
        }
    }

    private func showSuccess(_ message: String) {
        activityIndicator.stopAnimating()

        statusImageView.isHidden = false
        statusImageView.image = UIImage(systemName: "checkmark.circle.fill")
        statusImageView.tintColor = UIColor(red: 0.298, green: 0.851, blue: 0.392, alpha: 1.0) // Success green

        messageLabel.text = message
        messageLabel.textColor = .white

        // Show Done button for success
        buttonStackView.arrangedSubviews.forEach { buttonStackView.removeArrangedSubview($0) }
        buttonStackView.subviews.forEach { $0.removeFromSuperview() }

        buttonStackView.addArrangedSubview(actionButton)
        buttonStackView.isHidden = false

        actionButton.setTitle("Done", for: .normal)
        actionButton.backgroundColor = UIColor(red: 0.890, green: 0.145, blue: 0.318, alpha: 1.0) // #E32551 - brand color
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.borderWidth = 0

        // Auto-dismiss after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.dismissExtension()
        }
    }

    private func showError(_ title: String, message: String, canRetry: Bool = false) {
        activityIndicator.stopAnimating()

        titleLabel.text = title
        titleLabel.textColor = .white

        statusImageView.isHidden = false
        statusImageView.image = UIImage(systemName: "xmark.circle.fill")
        statusImageView.tintColor = UIColor(red: 1.0, green: 0.231, blue: 0.188, alpha: 1.0) // Error red

        messageLabel.text = message
        messageLabel.textColor = UIColor(white: 0.7, alpha: 1.0)

        if canRetry {
            // Clear and rebuild stack view for Retry + Cancel
            buttonStackView.arrangedSubviews.forEach { buttonStackView.removeArrangedSubview($0) }
            buttonStackView.subviews.forEach { $0.removeFromSuperview() }

            buttonStackView.addArrangedSubview(actionButton)
            buttonStackView.addArrangedSubview(retryButton)

            buttonStackView.isHidden = false

            actionButton.setTitle("Cancel", for: .normal)
            actionButton.backgroundColor = .clear
            actionButton.setTitleColor(.white, for: .normal)
            actionButton.layer.borderWidth = 1
            actionButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        } else {
            // For single button errors
            buttonStackView.arrangedSubviews.forEach { buttonStackView.removeArrangedSubview($0) }
            buttonStackView.subviews.forEach { $0.removeFromSuperview() }

            buttonStackView.addArrangedSubview(actionButton)
            buttonStackView.isHidden = false

            actionButton.setTitle("Done", for: .normal)
            actionButton.backgroundColor = UIColor(red: 0.890, green: 0.145, blue: 0.318, alpha: 1.0) // #E32551 - brand color
            actionButton.setTitleColor(.white, for: .normal)
            actionButton.layer.borderWidth = 0
        }
    }

    @objc private func actionButtonTapped() {
        dismissExtension()
    }

    @objc private func retryButtonTapped() {
        if let url = currentUrl {
            processUrl(url)
        }
    }

    @objc private func dismissExtension() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
