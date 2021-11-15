//
//  PurchaseHistoryVC.swift
//  BookManagement
//
//  Created by Rahul Pasi on 14/10/21.
//

import UIKit

class PurchaseHistoryVC: UIViewController {
    
    @IBOutlet weak var historyBookTbl: UITableView!
    @IBOutlet weak var countrySearch: UISearchBar!

    var historyArrData = [AddBookModel]()
    var historyArrPurchaseOnly = [AddBookModel]()
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
        historyArrData.removeAll()
        historyArrPurchaseOnly.removeAll()
        searchedCountry.removeAll()
        searching = false
        countrySearch.text = ""
        self.view.endEditing(true)
        historyArrData = DatabaseManager.getInstance().getAllBooksData()
        for i in 0..<historyArrData.count {
            if historyArrData[i].isPurchase == 1 {
                historyArrPurchaseOnly.append(historyArrData[i])
            }
        }
        if historyArrPurchaseOnly.count == 0 {
            historyBookTbl.setNoDataView(message: Messages.noResultFound)
        } else {
            historyBookTbl.backgroundView = nil
        }
        historyBookTbl.reloadData()
    }
}

// MARK: - Functions and IBAction methods
extension PurchaseHistoryVC {
    private func setupTable() {
        countrySearch.delegate = self
        self.tabBarController?.navigationItem.title = Title.purchaseHistory
        historyBookTbl.registerCell(cellId: .cellPurchaseHistory)
        historyBookTbl.rowHeight = UITableView.automaticDimension
        historyBookTbl.delegate = self
        historyBookTbl.dataSource = self
        historyBookTbl.estimatedRowHeight = 143
        historyBookTbl.tableFooterView = UIView()
    }
    @objc func onClickDelete(_ sender: UIButton){
        var selectedCountry = historyArrPurchaseOnly[sender.tag]
        if searching {
            selectedCountry = searchedCountry[sender.tag]
            print("searching : \(selectedCountry)")
        } else {
            selectedCountry = historyArrPurchaseOnly[sender.tag]
            print("Not searching : \(selectedCountry)")
        }
        
        UIAlertController.showAlertDialogWithMultipleOption(self, message: Messages.deleteItem, title: "\(CommonString.bookName) \(selectedCountry.bookName)", okTitle: CommonString.confirm, clickAction: {
            let isDeleted = DatabaseManager.getInstance().deleteBook(modelInfo: selectedCountry)
            if self.searching {
                self.searchedCountry.remove(at: sender.tag)
            } else {
                self.historyArrPurchaseOnly.remove(at: sender.tag)
            }
            self.historyBookTbl.reloadData()
            print("isDeleted :- \(isDeleted)")
        }) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatDDMMYYYY
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = DateFormat.dateFormatDMMMYYYY
        return  dateFormatter.string(from: date!)
        
    }
}

// MARK: - Tableview Datasource
extension PurchaseHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCountry.count
        } else {
            return historyArrPurchaseOnly.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CellPurchaseHistory.self, for: indexPath)
        var arrOfBook = historyArrPurchaseOnly[indexPath.row]
        if searching {
            arrOfBook = searchedCountry[indexPath.row]
        } else {
            arrOfBook = historyArrPurchaseOnly[indexPath.row]
        }
        cell.selectionStyle = .none
        if arrOfBook.isPurchase == 1 {
            cell.bookNameLbl.text = arrOfBook.bookName
            cell.authorNameLbl.text = arrOfBook.authorName
            cell.priceLbl.text = "\(arrOfBook.price)"
            cell.shortDescriptionLbl.text = arrOfBook.bookDescription
            cell.pruchasedDateLbl.text = convertDateFormater(arrOfBook.purchaseDate )
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        }
        return cell
    }
}
// MARK: - Tableview Delegate
extension PurchaseHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searching {
            let selectedCountry = searchedCountry[indexPath.row]
            print("searching : \(selectedCountry)")
        } else {
            let selectedCountry = historyArrPurchaseOnly[indexPath.row]
            print("Not searching : \(selectedCountry)")
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
        historyBookTbl.reloadRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row && isCollapsed == true {
            return UITableView.automaticDimension
        } else {
            return 143
        }
    }

}
extension PurchaseHistoryVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCountry = historyArrPurchaseOnly.filter({$0.authorName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        historyBookTbl.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.view.endEditing(true)
        historyBookTbl.reloadData()
    }
    
}
