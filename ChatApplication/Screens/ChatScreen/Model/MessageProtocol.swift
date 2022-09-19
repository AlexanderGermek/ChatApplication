//
//  MessageProtocol.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 19.09.2022.
//

import Foundation

protocol MessageProtocol {
	var text: String { get set }
	var date: Date { get set }
	var isSender: Bool { get set }
	var ownerName: String? { get set }
	var ownerProfileImage: String? { get set }
}

struct ServerMessage: MessageProtocol {
	var text: String
	var date: Date
	var isSender: Bool
	var ownerName: String? = nil
	var ownerProfileImage: String? = nil
}
