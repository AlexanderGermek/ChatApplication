//
//  DetailMessageScreenViewController.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 19.09.2022.
//

import UIKit

final class DetailMessageScreenViewController: UIViewController {
	var presenter: DetailMessageScreenPresenterProtocol

	// MARK: - UI components
	private let timeLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 12)
		label.textAlignment = .center
		return label
	}()

	private let messageTextView: UITextView = {
		let textView = UITextView()
		textView.font = .systemFont(ofSize: 18)
		textView.backgroundColor = .systemBackground
		textView.textAlignment = .center
		textView.isUserInteractionEnabled = false
		return textView
	}()

	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		return formatter
	}()

	// MARK: - Lifecycle
	init(presenter: DetailMessageScreenPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		addGestures()
		addDeleteBarButtonItem()
		addSubviews()
		presenter.didLoadView()
	}

	// MARK: - Private
	private func addGestures() {
		let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
		swipeGesture.direction = .right
		view.addGestureRecognizer(swipeGesture)
	}

	private func addDeleteBarButtonItem() {
		let button = UIButton(type: .custom)
		let trashImage = UIImage(systemName: "trash")
		button.setImage(trashImage, for: .normal)
		button.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
		let barButton = UIBarButtonItem(customView: button)
		navigationItem.rightBarButtonItem = barButton

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад",
														   style: .plain,
														   target: self,
														   action: #selector(backButtonTapped))
	}

	private func addSubviews() {

		_ = [timeLabel, messageTextView].compactMap {
			$0.isHidden = true
			$0.layer.opacity = 0
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}

		NSLayoutConstraint.activate([
			timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			timeLabel.heightAnchor.constraint(equalToConstant: 40),

			messageTextView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
			messageTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			messageTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			messageTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	@objc private func trashButtonTapped() {
		presenter.deleteMessage()
		presenter.closeScreen()
	}

	@objc private func backButtonTapped() {
		presenter.closeScreen()
	}

	@objc private func didSwipe() {
		presenter.closeScreen()
	}
}

// MARK: - DetailMessageScreenViewProtocol
extension DetailMessageScreenViewController: DetailMessageScreenViewProtocol {
	func configureUI(message: MessageProtocol) {
		// - timeLabel
		timeLabel.text = dateFormatter.string(from: message.date)

		// - userImage
		let imageView = ImageViewWithLoader(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
		imageView.contentMode = .scaleAspectFit
		imageView.loadimageFrom(isSender: message.isSender)
		navigationItem.titleView = imageView

		// - messageTextView
		messageTextView.text = message.text

		// - Animation
		DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
			UIView.animate(withDuration: 1) {
				self.timeLabel.isHidden = false
				self.messageTextView.isHidden = false
				self.timeLabel.layer.opacity = 1
				self.messageTextView.layer.opacity = 1
			}
		}
	}

	func dissmis(animated: Bool) {
		navigationController?.dismiss(animated: animated)
	}
}
