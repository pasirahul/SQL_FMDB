//
//  DashboardVC.swift
//  BookManagement
//
//  Created by Rahul Pasi on 14/10/21.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var countrySearch: UISearchBar!
    @IBOutlet weak var bookHomeTbl: UITableView!

    var bookArrData = [AddBookModel]()
    var searchedCountry = [AddBookModel]()
    var searching = false
    var selectedIndex = -1
    var isCollapsed = false

    // MARK: - UIView controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchedCountry.removeAll()
        searching = false
        countrySearch.text = ""
        self.view.endEditing(true)
        bookArrData = DatabaseManager.getInstance().getAllBooksData()
        print("bookArrData : \(bookArrData)")
        if bookArrData.count == 0 {
            bookHomeTbl.setNoDataView(message: Messages.noResultFound)
        } else {
            bookHomeTbl.backgroundView = nil
        }
        bookHomeTbl.reloadData()
    }
}

// MARK: - Functions and IBAction methods
extension DashboardVC {
    private func setupTable() {
        countrySearch.delegate = self
        self.tabBarController?.navigationItem.title = Title.bookList
        bookHomeTbl.registerCell(cellId: .cellDashboardBook)
        bookHomeTbl.rowHeight = UITableView.automaticDimension
        bookHomeTbl.delegate = self
        bookHomeTbl.dataSource = self
        bookHomeTbl.estimatedRowHeight = 117
        bookHomeTbl.tableFooterView = UIView()
    }
    @objc func onClickPurchase(_ sender: UIButton){
        var selectedBook = bookArrData[sender.tag]
        if searching {
            selectedBook = searchedCountry[sender.tag]
            print("searching : \(selectedBook)")
        } else {
            selectedBook = bookArrData[sender.tag]
            print("Not searching : \(selectedBook)")
        }
        
        if selectedBook.isPurchase == 0 {
            UIAlertController.showAlertDialogWithMultipleOption(self, message: "\(CommonString.price) \(selectedBook.price)", title: "\(CommonString.bookName) \(selectedBook.bookName)", okTitle: CommonString.confirm, clickAction: {
                let getCurrentDate = Date.getCurrentDate()
                let bookArr = selectedBook
                let book = AddBookModel(id: bookArr.id, bookName: bookArr.bookName, authorName: bookArr.authorName, price: bookArr.price, synopsis: bookArr.synopsis, quantity: bookArr.quantity, bookDescription: bookArr.bookDescription, purchaseDate: getCurrentDate, isPurchase: 1)
                let isUpdate = DatabaseManager.getInstance().updateBook(modelInfo: book)
                print("isUpdate :- \(isUpdate)")
                self.viewWillAppear(true)
                self.bookHomeTbl.reloadData()
            }) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}

// MARK: - Tableview Datasource
extension DashboardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCountry.count
        } else {
            return bookArrData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CellDashboardBook.self, for: indexPath)
        var arrOfBook = bookArrData[indexPath.row]
        if searching {
            arrOfBook = searchedCountry[indexPath.row]
        } else {
            arrOfBook = bookArrData[indexPath.row]
        }

        cell.selectionStyle = .none
        cell.bookNameLbl.text = arrOfBook.bookName
        cell.authorNameLbl.text = arrOfBook.authorName
        cell.priceLbl.text = "\(arrOfBook.price)"
        cell.shortDescriptionLbl.text = arrOfBook.bookDescription
        cell.purchaseBtn.tag = indexPath.row
        cell.purchaseBtn.addTarget(self, action: #selector(onClickPurchase(_:)), for: .touchUpInside)
        
        if arrOfBook.isPurchase == 0 {
            cell.purchaseBtn.setTitle(Title.buy, for: .normal)
            cell.purchaseBtn.backgroundColor = .black
        } else {
            cell.purchaseBtn.setTitle(Title.sell, for: .normal)
            cell.purchaseBtn.backgroundColor = .systemGreen
        }
        return cell
    }
}
// MARK: - Tableview Delegate
extension DashboardVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if searching {
            let selectedBook = searchedCountry[indexPath.row]
            print("searching : \(selectedBook)")
        } else {
            let selectedBook = bookArrData[indexPath.row]
            print("Not searching : \(selectedBook)")
        }
        // Close keyboard when you select cell
        self.countrySearch.searchTextField.endEditing(true)
        
        if selectedIndex == indexPath.row {
            if isCollapsed == false {
                isCollapsed = true
            } else {
                isCollapsed = false
            }
        } else {
            isCollapsed = true
        }
        selectedIndex = indexPath.row
        bookHomeTbl.reloadRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row && isCollapsed == true {
            return UITableView.automaticDimension
        } else {
            return 117
        }
    }

}
extension DashboardVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCountry = bookArrData.filter({$0.authorName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        bookHomeTbl.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.view.endEditing(true)
        bookHomeTbl.reloadData()
    }
    
}
