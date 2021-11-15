
import Foundation
var shareInstance = DatabaseManager()
class DatabaseManager: NSObject{
    
    var database:FMDatabase? = nil
    
    
    class func getInstance() -> DatabaseManager{
        if shareInstance.database == nil{
            shareInstance.database = FMDatabase(path: Util.getPath(dbName))
        }
        return shareInstance
    }
    
    //MARK: - For Insert data
    func saveData(_ modelInfo:AddBookModel) -> Bool{
        shareInstance.database?.open()
        let isSave = shareInstance.database?.executeUpdate("INSERT INTO BookManagement (bookName,authorName,price,synopsis,quantity,bookDescription,purchaseDate) VALUES (?,?,?,?,?,?,?)", withArgumentsIn: [modelInfo.bookName,modelInfo.authorName,modelInfo.price,modelInfo.synopsis,modelInfo.quantity,modelInfo.bookDescription,modelInfo.purchaseDate])
        shareInstance.database?.close()
        return isSave!
    }
    
    //MARK: - Get All data
    func getAllBooksData() -> [AddBookModel]{
        shareInstance.database?.open()
        let resultSet : FMResultSet! = try! shareInstance.database?.executeQuery("SELECT * FROM BookManagement", values: nil)
        var allStudents = [AddBookModel]()
        
        if resultSet != nil{
            while resultSet.next() {
                let studentModel = AddBookModel(id: Int(resultSet.int(forColumn: "id")), bookName: resultSet.string(forColumn: "bookName")!, authorName: resultSet.string(forColumn: "authorName")!, price: Int(resultSet.int(forColumn: "price")), synopsis: resultSet.string(forColumn: "synopsis")!, quantity: Int(resultSet.int(forColumn: "quantity")), bookDescription: resultSet.string(forColumn: "bookDescription")!, purchaseDate: resultSet.string(forColumn: "purchaseDate")!, isPurchase: Int(resultSet.int(forColumn: "isPurchase")))
                    
                allStudents.append(studentModel)
            }
        }
        shareInstance.database?.close()
        return allStudents
    }
    
    
    //MARK: - Update data
    func updateBook(modelInfo: AddBookModel) -> Bool{
        shareInstance.database?.open()
        
        let isUpdated = shareInstance.database?.executeUpdate("UPDATE BookManagement SET purchaseDate=? , isPurchase=?  WHERE id=? ", withArgumentsIn: [modelInfo.purchaseDate,modelInfo.isPurchase,modelInfo.id])
        
        shareInstance.database?.close()
        return isUpdated!
    }
    
    
    //MARK: - Deleting data
    func deleteBook(modelInfo: AddBookModel) -> Bool{
        shareInstance.database?.open()
        let isDeleted = (shareInstance.database?.executeUpdate("DELETE FROM BookManagement WHERE id=?", withArgumentsIn: [modelInfo.id]))
        shareInstance.database?.close()
        return isDeleted!
    }
    
}
