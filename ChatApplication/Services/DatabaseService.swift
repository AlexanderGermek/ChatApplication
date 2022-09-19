//
//  DatabaseService.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 19.09.2022.
//

import Foundation
import CoreData

protocol DatabaseServiceProtocol {
	var context: NSManagedObjectContext { get }
	func loadStoredData() -> [Message]
	func saveData()
	func deleteData(entity: String)
	func delete(object: Message)
	func addMessageInContext(text: String) -> Message
}

final class DatabaseService: DatabaseServiceProtocol {
	let context: NSManagedObjectContext

	init(context: NSManagedObjectContext) {
		self.context = context
	}

	func loadStoredData() -> [Message] {

		let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

		var messages: [Message] = []

		do {
			let managedMessages = try context.fetch(fetchRequest)
			messages.append(contentsOf: managedMessages)
		} catch let error as NSError {
			fatalError("Couldn't fetch. \(error), \(error.userInfo)")
		}

		return messages
	}

	func saveData() {
		do {
			try context.save()
		} catch let error as NSError{
			fatalError("Couldn't save! \(error), \(error.userInfo)")
		}
	}

	func deleteData(entity: String) {

		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
		fetchRequest.returnsObjectsAsFaults = false
		do {
			let results = try context.fetch(fetchRequest)
			for object in results {
				guard let objectData = object as? NSManagedObject else { continue }
				context.delete(objectData)
			}

			try context.save()
		} catch let error {
			print("Detele all data in \(entity) error :", error)
		}
	}

	func delete(object: Message) {
		context.delete(object)
		saveData()
	}

	func addMessageInContext(text: String) -> Message {
		let newMessage = Message(context: context)
		newMessage.text = text
		newMessage.isSender = true
		newMessage.date = Date()
		newMessage.ownerName = "Sender"
		newMessage.ownerProfileImage = "sender_image"
		saveData()
		return newMessage
	}
}
