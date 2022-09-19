//
//  NetworkService.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 18.09.2022.
//


import Foundation
import UIKit

struct MessagesResponseModel: Decodable {
	let result: [String]
}

protocol NetworkServiceProtocol {
	func fetchData(offset: Int, completion: @escaping (Result<MessagesResponseModel, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
	enum HTTPMethod: String {
		case GET
	}
	private let mainURL = "https://numia.ru/api/getMessages?offset="

	func fetchData(offset: Int, completion: @escaping (Result<MessagesResponseModel, Error>) -> Void) {
		guard let url = URL(string: "\(mainURL)\(offset)") else { return }
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.GET.rawValue
		request.timeoutInterval = 3

		let task = URLSession.shared.dataTask(with: request) { data, _, error in
			guard let data = data, error == nil else {
				completion(.failure(error!))
				return
			}

			do {
				let messages = try JSONDecoder().decode(MessagesResponseModel.self, from: data)
				completion(.success(messages))
			} catch {
				completion(.failure(error))
			}

		}

		task.resume()
	}


	lazy var cachedImages: [Bool: UIImage] = [:]

	func loadImageFrom(isSender: Bool, URLAddress: String, completion: @escaping ((UIImage) -> Void)) {
		guard let url = URL(string: URLAddress) else { return }
		if let cachedImage = cachedImages[isSender] {
			completion(cachedImage)
		} else {
			DispatchQueue.global().async { [weak self] in
				if let imageData = try? Data(contentsOf: url) {
					if let loadedImage = UIImage(data: imageData) {
						self?.cachedImages[isSender] = loadedImage
						completion(loadedImage)
					}
				}
			}
		}
	}
}
