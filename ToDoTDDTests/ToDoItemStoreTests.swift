//
//  ToDoItemStoreTests.swift
//  ToDoTDDTests
//
//  Created by Bikram Aryal on 02/05/2023.
//

import XCTest
@testable import ToDoTDD
import Combine

final class ToDoItemStoreTests: XCTestCase {
    
    
    var sut: ToDoItemStore!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ToDoItemStore(fileName: "dummy_store")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        
        let url = FileManager
            .default
            .documentsURL(name: "dummy_store")
            
            
            try? FileManager.default.removeItem(at: url)
      
        
    }
    
    func test_add_shouldPublishChange() throws {
        
        let toDoItem = ToDoItem(title: "Dummy")
        
        let receivedItems = try wait (for: sut.itemPublisher, afterChange: {
            sut.add(toDoItem)
        })
        
    
        XCTAssertEqual(receivedItems, [toDoItem])
    }
    
    func test_check_shouldPublishChangeInDoneItems()  throws {
        
        
        let toDoItem = ToDoItem(title: "Dummy")
        
        sut.add(toDoItem)
        
        sut.add(ToDoItem(title: "Dummy 2"))
        let receivedItems = try wait(for: sut.itemPublisher) {
            sut.check(toDoItem)
        }
        
        let doneItems = receivedItems.filter({ $0.done})
        XCTAssertEqual(doneItems, [toDoItem])
    }
    
    
    func test_init_shouldLoadPreviousToDoItems() throws {

        var sut1: ToDoItemStore? = ToDoItemStore(fileName: "dummy_store")
        
        let publisherException = expectation(description: "Wait for publisher in \(#file)")
        
        let toDoItem = ToDoItem(title: "Dummy Title")
        
        sut1?.add(toDoItem)
        
        sut1 = nil
        
        let sut2 = ToDoItemStore(fileName: "dummy_store")
        
        var result: [ToDoItem]?
        
        let token = sut2.itemPublisher
            .sink { value in
                result = value
                publisherException.fulfill()
            }
        
        wait(for: [publisherException], timeout: 1)
        token.cancel()
        XCTAssertEqual(result, [toDoItem])
    }
    
    
    func test_init_whenItemIsChecked_shouldLoadPreviousToDoItems() throws {
        
        var sut1: ToDoItemStore? = ToDoItemStore(fileName: "dummy_store")
        
        let publisherExpection = expectation(description: "Wait for publisher in \(#file)")
        
        let toDoItem = ToDoItem(title: "Dummy Title")
        
        sut1?.add(toDoItem)
        sut1?.check(toDoItem)
        
        sut1 = nil
        
        let sut2 = ToDoItemStore(fileName: "dummy_store")
        
        var result: [ToDoItem]?
        
        let token = sut2.itemPublisher
            .sink { value in
                result = value
                publisherExpection.fulfill()
            }
        
        wait(for: [publisherExpection], timeout: 1)
        token.cancel()
        
        XCTAssertEqual(result?.first?.done, true)
        
    }


}


extension XCTestCase {
    func wait<T: Publisher>(
        for publisher: T,
        afterChange change: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output where T.Failure == Never {
        let publisherExpectation = expectation(description: "Wait for publisher in \(#file)")
        
        var result: T.Output?
        
        let token = publisher
            .dropFirst()
            .sink { value in
                result = value
                publisherExpectation.fulfill()
            }
        
        change()
        wait(for: [publisherExpectation], timeout: 1)
        token.cancel()
        let unwrappedResult = try XCTUnwrap(result, "Publisher did not publish any value", file: file, line: line)
        
        return unwrappedResult
    }
}
