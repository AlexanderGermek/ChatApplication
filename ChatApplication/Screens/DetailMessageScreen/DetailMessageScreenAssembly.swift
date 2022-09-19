//
//  DetailMessageScreenAssembly.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 19.09.2022.
//

import UIKit

final class DetailMessageScreenAssembly: DetailMessageScreenAssemblyProtocol {
	func build(model: MessageProtocol,
			   modelIndex: IndexPath,
			   delegate: DetailMessageScreenPresenterDelegate) -> UIViewController {

		let presenter = DetailMessageScreenPresenter(model: model,
													 index: modelIndex,
													 delegate: delegate)
		let view = DetailMessageScreenViewController(presenter: presenter)

		presenter.view = view
		return view
	}
}


