//
//  ChatScreenPresenter.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 18.09.2022.
//

import UIKit

final class ChatScreenPresenter {
	// MARK: - Properties
	// - Protocol var's
	weak var view: ChatScreenViewControllerProtocol?
	let networkService: NetworkServiceProtocol
	let databaseService: DatabaseServiceProtocol

	// - Private var's
	private var isKeyboardOpen = false
	private var offset = 0
	private var storedMessages: [Message] = []
	private var allMessages: [MessageProtocol] = []
	private var wasGetAllMessagesFromServer = false
	private var isLoadNow = false

	// MARK: - Lifecycle
	init(networkService: NetworkServiceProtocol, databaseService: DatabaseServiceProtocol) {
		self.networkService = networkService
		self.databaseService = databaseService
		addKeyboardObservers()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

}

// MARK: - DetailMessageScreenPresenterDelegate
extension ChatScreenPresenter: DetailMessageScreenPresenterDelegate {
	func delete(message: MessageProtocol, at index: IndexPath) {
		if let storedMessage  = message as? Message {
			databaseService.delete(object: storedMessage)
		}
		allMessages.remove(at: index.item)
		view?.updateItems(at: [index], type: .delete)
	}
}

// MARK: - ChatScreenPresenterProtocol
extension ChatScreenPresenter: ChatScreenPresenterProtocol {

	func didLoadView() {
		// - Для удаления из локальной базы данных:
//		databaseService.deleteData(entity: "Message")

		allMessages.append(contentsOf: databaseService.loadStoredData())
		fetchDataFromServer()
	}

	func fetchDataFromServer() {
		guard !wasGetAllMessagesFromServer, !isLoadNow else { return }
		view?.startSpinnerAnimation()
		isLoadNow = true
		networkService.fetchData(offset: offset) { [unowned self] result in
			switch result {
				case .success(let data):
					guard !data.result.isEmpty else {
						wasGetAllMessagesFromServer = true
						DispatchQueue.main.async {
							self.view?.stopSpinnerAnimation()
						}
						return
					}

					allMessages.append(contentsOf: self.buildServerMessages(data: data))
					self.offset += data.result.count

					let startIndex = allMessages.count - data.result.count
					var indexes: [IndexPath] = []
					for index in startIndex...allMessages.count-1 {
						indexes.append(IndexPath(item: index, section: 0))
					}
					DispatchQueue.main.async {
						self.isLoadNow = false
						self.view?.updateItems(at: indexes, type: .insert)
					}
				case .failure:
					DispatchQueue.main.async {
						self.isLoadNow = false
						self.view?.showTryAgainButton()
					}
			}
		}
	}

	func getAllMessagesCount() -> Int {
		return allMessages.count
	}

	func getMessageFor(indexPath: IndexPath) -> MessageProtocol {
		return allMessages[indexPath.item]
	}

	func sendMessage(text: String) {
		let newMessage = databaseService.addMessageInContext(text: text)
		allMessages.insert(newMessage, at: 0)
		view?.animateAddingMessage()
	}
}

// MARK: - Additional functions
extension ChatScreenPresenter {
	// - Private
	private func addKeyboardObservers() {
		// keyboardWillShow
		NotificationCenter.default.addObserver(self,
											   selector: #selector(handleKeyboardNotification),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)

		// keyboardWillHide
		NotificationCenter.default.addObserver(self,
											   selector: #selector(handleKeyboardNotification),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
	}

	private func buildServerMessages(data: MessagesResponseModel) -> [ServerMessage] {
		return data.result.compactMap { text in
			return ServerMessage(text: text,
								 date: Date(),
								 isSender: [true, false].randomElement() ?? false,
								 ownerName: nil,
								 ownerProfileImage: nil)
		}
	}

	// - Selectors
	@objc private func handleKeyboardNotification(notification: Notification) {
		switch notification.name {

			case UIResponder.keyboardWillShowNotification:
				if isKeyboardOpen { return }
				guard let userInfo = notification.userInfo else { return }
				if let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
					isKeyboardOpen = true
					view?.updateBottomConstraint(constant: -keyboardFrame.height)
				}

			case UIResponder.keyboardWillHideNotification:
				if !isKeyboardOpen { return }
				isKeyboardOpen = false
				view?.updateBottomConstraint(constant: 0)
			default: return
		}
	}
}



