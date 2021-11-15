
import Foundation
import UIKit

let dbName = "BookManagement.db"

enum DateFormat {
    static let dateFormatDDMMYYYY = "dd/MM/yyyy"
    static let dateFormatDMMMYYYY = "d MMM, yyyy"
}

enum Messages {
    static let deleteItem = "Are you sure you want to delete this item ?"
    static let noResultFound = "No Result Found"
}

enum ValidationMsg {
    static let emptyBookName = "Enter Book Name"
    static let emptyAuthorName = "Enter Author Name"
    static let emptySynopsis = "Enter Synopsis"
    static let emptyPrice = "Enter Book Name"
    static let emptyDescription = "Enter Description"
}

enum CommonString {
    static let confirm = "Confirm"
    static let bookName = "Book Name :"
    static let price = "Price :"
}

enum Title {
    static let buy = "Buy"
    static let sell = "Sell"
    static let bookList = "Book List"
    static let purchaseHistory = "Purchase History"
    static let addBook = "Add Book"
}
