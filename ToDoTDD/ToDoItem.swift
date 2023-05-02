//
//  ToDoItem.swift
//  ToDoTDD
//
//  Created by Bikram Aryal on 02/05/2023.
//

import Foundation


struct ToDoItem: Equatable {

    
    let title: String
    let itemDescription: String?
    let timestamp: TimeInterval?
    let location: Location?
    
    init(title: String, itemDescription: String? = nil, timestamp: TimeInterval? = nil, location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
}
