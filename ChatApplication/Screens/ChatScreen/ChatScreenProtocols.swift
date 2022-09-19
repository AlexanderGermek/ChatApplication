//
//  ChatScreenProtocols.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 19.09.2022.
//

import Foundation
import UIKit

protocol ChatScreenViewControllerProtocol: AnyObject {

	func updateBottomConstraint(constant: CGFloat)
	func updateItems(at: [IndexPath], type: UpdateType)
	func animateAddingMessage()
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
	func showTryAgainButton()
}

protocol ChatScreenPresenterProtocol: DetailMessageScreenPresenterDelegate {

	var networkService: NetworkServiceProtocol { get }
	var databaseService: DatabaseServiceProtocol { get }

	// - Functions
	func didLoadView()
	func fetchDataFromServer()
	func getAllMessagesCount() -> Int
	func getMessageFor(indexPath: IndexPath) -> MessageProtocol
	func sendMessage(text: String)
}

protocol ChatScreenAssemblyProtocol: AnyObject {
	func build() -> UIViewController
}
