//
//  ChatScreenAssembly.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 19.09.2022.
//

import Foundation
import UIKit

final class ChatScreenAssembly: ChatScreenAssemblyProtocol {

	func build() -> UIViewController {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return  UIViewController() }
		let managedContext = appDelegate.persistentContainer.viewContext


		let networkService = NetworkService()
		let databaseService = DatabaseService(context: managedContext)
		let presenter = ChatScreenPresenter(networkService: networkService, databaseService: databaseService)
		let view = ChatScreenViewController(presenter: presenter, collectionViewLayout: InvertedCollectionViewFlowLayout())

		presenter.view = view
		return view
	}
}
