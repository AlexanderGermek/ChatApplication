//
//  DetailMessageScreenProtocols.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 19.09.2022.
//

import UIKit

protocol DetailMessageScreenViewProtocol: AnyObject {
	func configureUI(message: MessageProtocol)
	func dissmis(animated: Bool)
}

protocol DetailMessageScreenPresenterProtocol: AnyObject {
	func didLoadView()
	func deleteMessage()
	func closeScreen()
}

protocol DetailMessageScreenPresenterDelegate: AnyObject {
	func delete(message: MessageProtocol, at: IndexPath)
}

protocol DetailMessageScreenAssemblyProtocol {
	func build(model: MessageProtocol,
			   modelIndex: IndexPath,
			   delegate: DetailMessageScreenPresenterDelegate) -> UIViewController
}
