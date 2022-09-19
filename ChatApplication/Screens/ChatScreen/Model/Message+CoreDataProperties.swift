//
//  Message+CoreDataProperties.swift
//  ChatApplication
//
//  Created by Гермек Александр Георгиевич on 18.09.2022.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var text: String
    @NSManaged public var date: Date
    @NSManaged public var isSender: Bool
    @NSManaged public var ownerName: String?
    @NSManaged public var ownerProfileImage: String?

}

extension Message : Identifiable {

}

extension Message: MessageProtocol { }
