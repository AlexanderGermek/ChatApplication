//
//  ImageViewWithLoader.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 18.09.2022.
//

import UIKit

final class ImageViewWithLoader: UIImageView {

	var cachedImages: [Bool: UIImage] = [:]
	var urlsForImages: [Bool: String] = [true: "https://avatars.dicebear.com/api/micah/.png",
										 false: "https://avatars.dicebear.com/api/big-smile/.png"]

	func loadimageFrom(isSender: Bool) {
		if let userImage = cachedImages[isSender] {
			self.image = userImage
		} else {
			let urlString = urlsForImages[isSender] ?? ""
			guard let url = URL(string: urlString) else { return }
			DispatchQueue.global().async { [weak self] in
				if let imageData = try? Data(contentsOf: url) {
					if let loadedImage = UIImage(data: imageData) {
						self?.cachedImages[isSender] = loadedImage
						DispatchQueue.main.async {
							self?.image = loadedImage
						}
					}
				} else {
					DispatchQueue.main.async {
						if self?.image == nil {
							self?.backgroundColor = .systemGray
						}
					}
				}
			}
		}
	}
}
