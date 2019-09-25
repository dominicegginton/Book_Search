//
//  Books.swift
//  Stack
//
//  Created by Dominic Egginton on 25/09/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import Foundation

struct Book {
    var id: String
    var title: String
    var author: String
}

struct BookDetails {
    var title: String
    var author: String
    var description: String
}

enum BookError: Error {
    case InvalidURL(String)
    case InvalidKey(String)
    case InvalidArray
    case InvalidData
    case InvalidImage
    case IndexOutOfRange
}

class Books {
    
    // Singleton Instance
    public static var sharedInstance = Books()
    
    var searchData: [Book]
    
    private init() {
        self.searchData = []
    }
    
    public func getBook(at index: Int) throws -> Book {
        return Book(id: "abc", title: "The Hobbit", author: "J.R.R Tolkien")
    }
    
    public var count: Int {
        return 0
    }
    
    public func search(withText text: String, _ completion: @escaping ()->()) throws {
        completion()
    }
    
    public func getDetails(withID: String, _ completion: @escaping (BookDetails)->()) throws {
        completion(BookDetails(title: "The Hobbit", author: "J.R.R Tolkien", description: "Decription of the hobbit"))
    }
    
}
