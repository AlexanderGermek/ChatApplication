//
//  DetailMessageScreenPresenter.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 19.09.2022.
//

import Foundation


final class DetailMessageScreenPresenter {
	weak var view: DetailMessageScreenViewProtocol?
	let message: MessageProtocol
	let delegate: DetailMessageScreenPresenterDelegate
	let index: IndexPath

	init(model: MessageProtocol,
		 index: IndexPath,
		 delegate: DetailMessageScreenPresenterDelegate)
	{
		self.message = model
		self.index = index
		self.delegate = delegate
	}
}

extension DetailMessageScreenPresenter: DetailMessageScreenPresenterProtocol {
	func didLoadView() {
		view?.configureUI(message: message)
	}

	func deleteMessage() {
		delegate.delete(message: message, at: index)
	}

	func closeScreen() {
		view?.dissmis(animated: true)
	}
}
