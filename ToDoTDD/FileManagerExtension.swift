//
//  FileManagerExtension.swift
//  ToDoTDD
//
//  Created by Bikram Aryal on 02/05/2023.
//

import Foundation


extension FileManager {
    func documentsURL(name: String) -> URL {
        guard let documentsURL = urls(for: .documentDirectory, in: .userDomainMask)
            .first else {
            fatalError()
        }
        return documentsURL.appending(path: name)
    }
}
