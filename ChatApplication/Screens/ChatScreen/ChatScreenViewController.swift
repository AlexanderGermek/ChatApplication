//
//  ChatScreenViewController.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 18.09.2022.
//

import UIKit

final class ChatScreenViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	// MARK: - Properties
	private var bottomConstraint: NSLayoutConstraint = .init()

	var presenter: ChatScreenPresenterProtocol

	// MARK: - UI Components
	private let mainLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .bold)
		label.text = "Чат"
		label.textAlignment = .center
		label.backgroundColor = UIColor.themableWhite
		label.layer.shadowColor = UIColor.systemGray2.cgColor
		label.layer.shadowOffset = CGSize(width: 0, height: 2)
		label.layer.shadowRadius = 1
		label.layer.shadowOpacity = 0.5
		label.layer.masksToBounds = false
		return label
	}()

	private let spinner: UIActivityIndicatorView = {
		let spinner = UIActivityIndicatorView()
		spinner.hidesWhenStopped = true
		spinner.style = .large
		return spinner
	}()

	private let messageInputContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.themableWhite
		return view
	}()

	private let inputTextField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		textField.placeholder = "Enter message..."
		textField.returnKeyType = .send
		return textField
	}()

	private let tryAgainButton: UIButton = {
		let button = UIButton()
		button.setTitle("Попробовать снова", for: .normal)
		button.setTitleColor(.label, for: .normal)
		button.layer.cornerRadius = 15
		button.titleLabel?.font = .systemFont(ofSize: 12)
		button.isHidden = true
		button.layer.shadowColor = UIColor.systemGray2.cgColor
		button.layer.shadowOffset = CGSize(width: 1, height: 2)
		button.layer.shadowRadius = 1
		button.layer.shadowOpacity = 0.8
		button.layer.masksToBounds = false
		button.backgroundColor = .systemBlue
		return button
	}()

	// MARK: - Lifecycle
	init(presenter: ChatScreenPresenterProtocol, collectionViewLayout layout: UICollectionViewLayout) {
		self.presenter = presenter
		super.init(collectionViewLayout: layout)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.themableWhite
		configureCollectionView()
		addTargets()
		addSubviews()
		presenter.didLoadView()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if presenter.getAllMessagesCount() != 0 {
			scrollToLastItem(animated: false)
		}
	}

	// MARK: - Private func's
	private func addSubviews() {
		let topBorderLineView = UIView()
		topBorderLineView.backgroundColor = .init(white: 0.5, alpha: 0.5)

		_ = [collectionView, messageInputContainerView, inputTextField,
			 topBorderLineView, mainLabel, spinner, tryAgainButton].compactMap {
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		view.addSubview(collectionView)
		view.addSubview(messageInputContainerView)
		view.addSubview(mainLabel)
		view.addSubview(spinner)
		view.addSubview(tryAgainButton)

		bottomConstraint = NSLayoutConstraint(item: messageInputContainerView,
											  attribute: .bottom,
											  relatedBy: .equal,
											  toItem: view,
											  attribute: .bottom,
											  multiplier: 1,
											  constant: 0)

		NSLayoutConstraint.activate([
			mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			mainLabel.heightAnchor.constraint(equalToConstant: 40),

			spinner.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
			spinner.heightAnchor.constraint(equalToConstant: 40),
			spinner.widthAnchor.constraint(equalToConstant: 40),
			spinner.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor),

			tryAgainButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
			tryAgainButton.heightAnchor.constraint(equalToConstant: 40),
			tryAgainButton.widthAnchor.constraint(equalToConstant: 140),
			tryAgainButton.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor),

			collectionView.topAnchor.constraint(equalTo: mainLabel.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: messageInputContainerView.topAnchor),

			messageInputContainerView.heightAnchor.constraint(equalToConstant: 48),
			bottomConstraint,
			messageInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			messageInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])

		messageInputContainerView.addSubview(inputTextField)
		messageInputContainerView.addSubview(topBorderLineView)

		NSLayoutConstraint.activate([
			inputTextField.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor),
			inputTextField.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor, constant: 16),
			inputTextField.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor),
			inputTextField.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor),

			topBorderLineView.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor),
			topBorderLineView.heightAnchor.constraint(equalToConstant: 0.5),
			topBorderLineView.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor),
			topBorderLineView.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor)
		])
	}

	private func scrollToLastItem(animated: Bool = true) {
		let indexPath = IndexPath(item: 0, section: 0)
		self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
	}

	private func configureCollectionView() {
		collectionView.register(ChatLogMessageCell.self,
								forCellWithReuseIdentifier: ChatLogMessageCell.reuseIdentifier)
		collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
		collectionView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 50, right: 0)
	}

	private func addTargets() {
		// - tryAgainButton
		tryAgainButton.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)

		// - tapGesture for hide keyboard
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedGesture(gesture:)))
		tapGesture.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGesture)

		// - inputTextField
		inputTextField.delegate = self
	}

	@objc private func tryAgainButtonTapped() {
		UIView.animate(withDuration: 0.04) {
			self.tryAgainButton.layer.opacity = 0
		}
		self.presenter.fetchDataFromServer()
	}


	@objc private func tappedGesture(gesture: UITapGestureRecognizer) {
		inputTextField.endEditing(true)
	}

	// MARK: - UICollectionViewDataSource
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return presenter.getAllMessagesCount()
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLogMessageCell.reuseIdentifier,
															for: indexPath) as? ChatLogMessageCell else {
			return UICollectionViewCell()
		}

		let message = presenter.getMessageFor(indexPath: indexPath)
		cell.configure(from: message)
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let message = presenter.getMessageFor(indexPath: indexPath)
		let detailVC = DetailMessageScreenAssembly().build(model: message,
														   modelIndex: indexPath,
														   delegate: presenter)
		let navVC = UINavigationController(rootViewController: detailVC)
		self.present(navVC, animated: true)
	}

	// MARK: - UICollectionViewDelegateFlowLayout
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {

		let message = presenter.getMessageFor(indexPath: indexPath)
		let messageLength = view.frame.width * 0.5
		let size = CGSize(width: messageLength, height: 1000)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		let estimatedFrame = NSString(string: message.text)
			.boundingRect(with: size,
						  options: options,
						  attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)],
						  context: nil)
		return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
	}
}

// MARK: - UITextFieldDelegate
extension ChatScreenViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text, !text.isEmpty else { return false }
		presenter.sendMessage(text: text)
		return true
	}
}

// MARK: - UIScrollViewDelegate
extension ChatScreenViewController {
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let position = scrollView.contentOffset.y
		let scrollDirectionIsUp = scrollView.panGestureRecognizer.velocity(in: scrollView).y < 0

		if position > collectionView.contentSize.height-scrollView.frame.size.height-100 && scrollDirectionIsUp {
			presenter.fetchDataFromServer()
		}
	}
}

// MARK: - ChatScreenViewControllerProtocol
extension ChatScreenViewController: ChatScreenViewControllerProtocol {

	func updateBottomConstraint(constant: CGFloat) {
		bottomConstraint.constant = constant
		UIView.animate(withDuration: 0.05) {
			self.view.layoutIfNeeded()
		}
	}

	func updateItems(at indexes: [IndexPath], type: UpdateType) {
		spinner.stopAnimating()
		switch type {
			case .insert:
				collectionView.performBatchUpdates {
					collectionView.insertItems(at: indexes)
				}
			case .delete:
				collectionView.performBatchUpdates {
					collectionView.deleteItems(at: indexes)
				}
		}
	}

	func animateAddingMessage() {
		UIView.animate(withDuration: 0.5) {
			self.inputTextField.text = nil
			self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
			self.scrollToLastItem()
		}
	}

	func startSpinnerAnimation() {
		tryAgainButton.isHidden = true
		spinner.startAnimating()
	}

	func stopSpinnerAnimation() {
		spinner.stopAnimating()
	}

	func showTryAgainButton() {
		tryAgainButton.isHidden = false
		UIView.animate(withDuration: 0.05) {
			self.tryAgainButton.layer.opacity = 1
			self.spinner.stopAnimating()
		}
	}
}
