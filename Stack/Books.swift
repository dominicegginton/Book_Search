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
    var publicationYear: String
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
        if self.searchData.indices.contains(index) {
            return self.searchData[index]
        } else {
            throw BookError.IndexOutOfRange
        }
    }
    
    public var count: Int {
        return self.searchData.count
    }
    
    public func clear() {
        self.searchData = []
    }
    
    public func search(withText text: String, _ completion: @escaping ()->()) throws {
        // replace spaces in string
        let searchText = text.replacingOccurrences(of: " ", with: "%20r")
        
        let urlString = "https://www.googleapis.com/books/v1/volumes?maxResults=40&fields=items(id,volumeInfo(title,authors,publishedDate))&q=\(searchText)"
        print("request url = \(urlString)")
        
        let session = URLSession.shared
        guard let requestURL = NSURL(string: urlString) else {
            throw BookError.InvalidURL(urlString)
        }
        
        session.dataTask(with: requestURL as URL, completionHandler: {(data, reponse, error) -> Void in
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                guard let items = responseJSON["items"] as! [[String: Any]]? else {
                    throw BookError.InvalidKey("items")
                }
                for item in items {
                    guard let id = item["id"] as! String? else {
                        throw BookError.InvalidKey("id")
                    }
                    guard let volumeInfo = item["volumeInfo"] as! [String: Any]? else {
                        throw BookError.InvalidKey("volumeInfo")
                    }
                    let title = volumeInfo["title"] as? String ?? "Title not found"
                    let authorArray = volumeInfo["authors"] as? [String] ?? ["Author not found"]
                    let author = authorArray.joined(separator: ", ")
                    
                    // add book to searchData
                    self.searchData.append(Book(id: id, title: title, author: author))
                }
            } catch {
                print("error thrown \(error)")
            }
            completion()
            }).resume()
    }
    
    public func getDetails(withID id: String, _ completion: @escaping (BookDetails)->()) throws {
        
        let urlString = "https://www.googleapis.com/books/v1/volumes/\(id)"
        print("request url = \(urlString)")
        
        let session = URLSession.shared
        guard let requestURL = NSURL(string: urlString) else {
            throw BookError.InvalidURL(urlString)
        }
        
        session.dataTask(with: requestURL as URL, completionHandler: {(data, reponse, error) -> Void in
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                guard let volumeInfo = responseJSON["volumeInfo"] as! [String: Any]? else {
                    throw BookError.InvalidKey("volumeInfo")
                }
                let title = volumeInfo["title"] as? String ?? "Title not found"
                let authorArray = volumeInfo["authors"] as? [String] ?? ["Author not found"]
                let author = authorArray.joined(separator: ", ")
                let descriptionString = volumeInfo["description"] as? String ?? "Decription not found"
                let description = self.cleanDescription(description: descriptionString)
                let publishedDateString = volumeInfo["publishedDate"] as? String
                let publishedYear = self.convertDateToYear(publishedDateString!) ?? "Published date not found"
                
                let bookDetails = BookDetails(title: title, author: author, description: description, publicationYear: publishedYear)
                completion(bookDetails)
            } catch {
                print("error thrown \(error)")
            }
            }).resume()
    }
    
    func convertDateToYear(_ dateAsString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        guard let formattedDate = dateFormatter.date(from: dateAsString) else {
            return nil
        }
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: formattedDate)
    }
    
    func cleanDescription(description dirtyDescription: String) -> String {
        return dirtyDescription
            .replacingOccurrences(of: "<br>", with: "\n")
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
            .replacingOccurrences(of: "<p>", with: "")
            .replacingOccurrences(of: "</p>", with: "")
            .replacingOccurrences(of: "<ul>", with: "\n")
            .replacingOccurrences(of: "</ul>", with: "\n")
            .replacingOccurrences(of: "<li>", with: "\n• ")
            .replacingOccurrences(of: "</li>", with: "")
    }
}
