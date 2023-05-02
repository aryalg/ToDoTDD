//
//  ToDoItemStore.swift
//  ToDoTDD
//
//  Created by Bikram Aryal on 02/05/2023.
//

import Foundation
import Combine


class ToDoItemStore {
    var itemPublisher = CurrentValueSubject<[ToDoItem], Never>([])
    
    var fileName: String
    
    private var items: [ToDoItem] = [] {
        didSet {
            itemPublisher.send(items)
        }
    }
    
    func add(_ item: ToDoItem) {
        items.append(item)
        saveItems()
    }
    
    func check(_ item: ToDoItem) {
        var mutableItem = item
        mutableItem.done = true
        
        if let index = items.firstIndex(of: item) {
            items[index] = mutableItem
            saveItems()
        }
    }
    
    init(fileName: String = "todoItems") {
        self.fileName = fileName
        loadItems()
    }
    
    private func saveItems() {
        let url = FileManager.default.documentsURL(name: fileName)
        
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: url)
        } catch {
            print("error: \(error)")
        }
        
    }
    
    private func loadItems() {
        let url = FileManager.default
            .documentsURL(name: fileName)
        
        do {
            let data = try Data(contentsOf: url)
            items = try JSONDecoder()
                .decode([ToDoItem].self, from: data)
        } catch {
            print("error: \(error)")
        }
    }
}
