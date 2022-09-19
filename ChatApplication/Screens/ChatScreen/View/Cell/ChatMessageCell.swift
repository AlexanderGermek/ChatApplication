//
//  ChatMessageCell.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 18.09.2022.
//

import UIKit

final class ChatLogMessageCell: UICollectionViewCell {

	// MARK: - Properties
	static let reuseIdentifier = "ChatLogMessageCell"

	enum Constants {
		static let userImageViewRadius: CGFloat = 15
	}

	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		return formatter
	}()

	// MARK: - UI components
	private let messageTextView: UITextView = {
		let textView = UITextView()
		textView.font = .systemFont(ofSize: 18)
		textView.backgroundColor = .clear
		textView.isUserInteractionEnabled = false
		return textView
	}()

	let timeLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 10)
		label.textAlignment = .right
		label.layer.zPosition = 2
		return label
	}()

	private let bubbleBackgroundView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 15
		return view
	}()

	private let userImageView: ImageViewWithLoader = {
		let imageView = ImageViewWithLoader()
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = 25
		imageView.layer.masksToBounds = true
		return imageView
	}()

	private let bubbleTrailImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.tintColor = .init(white: 0.90, alpha: 1)
		imageView.clipsToBounds = false
		return imageView
	}()

	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.clipsToBounds = true
		addSubviews()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		messageTextView.text = nil
		bubbleBackgroundView.backgroundColor = .clear
		userImageView.image = nil
		userImageView.backgroundColor = .clear
		bubbleTrailImageView.backgroundColor = .clear
		timeLabel.textColor = nil
		messageTextView.textColor = nil
	}

	// MARK: - Private functions
	private func addSubviews() {
		addSubview(bubbleBackgroundView)
		addSubview(messageTextView)
		addSubview(userImageView)
		addSubview(timeLabel)
		bubbleBackgroundView.addSubview(bubbleTrailImageView)
	}

	private func estimateFrameForMessage(text: String) -> CGRect {
		let messageLength = contentView.frame.width * 0.5

		let size = CGSize(width: messageLength, height: .infinity)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		let estimatedFrame = NSString(string: text)
			.boundingRect(with: size, options: options,
						  attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)],
						  context: nil)
		return estimatedFrame
	}

	private func bubbleTrail(named: String) -> UIImage? {
		let edges = UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21)
		return UIImage(named: named)?.resizableImage(withCapInsets: edges, resizingMode: .stretch)
	}

	func configure(from message: MessageProtocol) {
		messageTextView.text = message.text
		timeLabel.textColor = .systemGray

		let estimatedFrame = estimateFrameForMessage(text: message.text)
		let horizontalOffset: CGFloat = 8
		let width = contentView.frame.width

		if message.isSender { // сообщения справа
			userImageView.loadimageFrom(isSender: message.isSender)
			bubbleTrailImageView.image = bubbleTrail(named: "bubble_sent")
			messageTextView.textColor = .white

			// - Frames
			messageTextView.frame = CGRect(x: width-estimatedFrame.width-46-8-horizontalOffset+6-20,
										   y: -4,
										   width: estimatedFrame.width+16,
										   height: estimatedFrame.height+20)

			bubbleBackgroundView.frame = CGRect(x: width-estimatedFrame.width-46-8-16+8-20,
												y: -4,
												width: estimatedFrame.width+horizontalOffset+16,
												height: estimatedFrame.height+20)

			userImageView.frame = CGRect(x: width-38-20,
										 y: messageTextView.frame.height-50,
										 width: 50,
										 height: 50)

			let parent = bubbleBackgroundView.frame
			timeLabel.frame = CGRect(x: parent.minX-54,
									 y: parent.maxY-18,
									 width: 50, height: 20)

		} else { // сообщения слева

			userImageView.loadimageFrom(isSender: message.isSender)
			bubbleTrailImageView.image = bubbleTrail(named: "bubble_received")
			messageTextView.textColor = .black

			// - Frames
			messageTextView.frame = CGRect(x: 42+horizontalOffset+20, y: -4,
												width: estimatedFrame.width+16,
												height: estimatedFrame.height+20)

			bubbleBackgroundView.frame = CGRect(x: 38+20, y: -4,
													 width: estimatedFrame.width+horizontalOffset+16,
													 height: estimatedFrame.height+20)
			let y = messageTextView.frame.height-50
			userImageView.frame = CGRect(x: 8, y: y, width: 50, height: 50)

			let parent = bubbleBackgroundView.frame
			timeLabel.frame = CGRect(x: parent.maxX-4,
									 y: parent.maxY-18,
									 width: 50, height: 20)

		}

		// - Commons
		bubbleTrailImageView.frame = bubbleBackgroundView.bounds
		timeLabel.text = dateFormatter.string(from: message.date)
	}
}
