//
//  InvertedCollectionViewFlowLayout.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 19.09.2022.
//

import UIKit

final class InvertedCollectionViewFlowLayout: UICollectionViewFlowLayout {

	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		let attrs = super.layoutAttributesForItem(at: indexPath)
		attrs?.transform = CGAffineTransform(scaleX: 1, y: -1)
		return attrs
	}

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let attrsList = super.layoutAttributesForElements(in: rect)
		if let list = attrsList {
			for i in 0..<list.count {
				list[i].transform = CGAffineTransform(scaleX: 1, y: -1)
			}
		}
		return attrsList
	}
}
