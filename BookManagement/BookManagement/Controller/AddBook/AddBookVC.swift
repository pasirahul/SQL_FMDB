//
//  AddBookVC.swift
//  BookManagement
//
//  Created by Rahul Pasi on 14/10/21.
//

import UIKit

class AddBookVC: UIViewController {

    @IBOutlet weak var bookNameTxt: UITextField!
    @IBOutlet weak var authorNameTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var synopsisTxt: UITextField!
    @IBOutlet weak var quantityTxt: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    let placeholderForTxtView = "Enter Book Description"
    
    // MARK: - UIView controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }    

}

// MARK: - IBAction and functions
extension AddBookVC {
    private func setupTable() {
        self.tabBarController?.navigationItem.title = Title.addBook
        descriptionTxtView.delegate = self
        descriptionTxtView.layer.cornerRadius = 6.0
        saveBtn.layer.cornerRadius = 10.0
        descriptionTxtView.text = placeholderForTxtView
        descriptionTxtView.textColor = UIColor.lightGray
    }
    func validationAll() -> Bool {
        var flag: Bool = true
        if bookNameTxt.text?.trimming().isEmpty == true {
            flag = false
            UIAlertController.showAlertDialog(self, message: ValidationMsg.emptyBookName)
            return false
        }
        if authorNameTxt.text?.trimming().isEmpty == true {
            flag = false
            UIAlertController.showAlertDialog(self, message: ValidationMsg.emptyAuthorName)
            return false
        }
        if synopsisTxt.text?.trimming().isEmpty == true {
            flag = false
            UIAlertController.showAlertDialog(self, message: ValidationMsg.emptySynopsis)
            return false
        }
        if priceTxt.text?.trimming().isEmpty == true {
            flag = false
            UIAlertController.showAlertDialog(self, message: ValidationMsg.emptyPrice)
            return false
        }
        if descriptionTxtView.text?.trimming().isEmpty == true {
            flag = false
            UIAlertController.showAlertDialog(self, message: ValidationMsg.emptyDescription)
            return false
        }
        return flag
    }
    
    func clearAllValue() {
        bookNameTxt.text = ""
        authorNameTxt.text = ""
        synopsisTxt.text = ""
        priceTxt.text = ""
        descriptionTxtView.text = ""
        quantityTxt.text = ""
    }
    
    @IBAction func clickedOnSaveBtn(_ sender: UIButton) {
        let priceValue = Int(priceTxt.text ?? "")
        let quantityValue = Int(quantityTxt.text ?? "")
        let getCurrentDate = Date.getCurrentDate()
        
        if validationAll() {
            let modelInfo = AddBookModel(id: 0, bookName: bookNameTxt.text ?? "", authorName: authorNameTxt.text ?? "", price: priceValue ?? 0, synopsis: synopsisTxt.text ?? "", quantity: quantityValue ?? 0, bookDescription: descriptionTxtView.text.trimming(), purchaseDate: getCurrentDate, isPurchase: 0)
            let isSave = DatabaseManager.getInstance().saveData(modelInfo)
            print(isSave)
            clearAllValue()
            self.tabBarController?.selectedIndex = 0
        }
        
    }

}

// MARK: - UITextViewDelegate methods
extension AddBookVC: UITextViewDelegate {

    func textView(_ textView: UITextView,  shouldChangeTextIn range:NSRange, replacementText text:String ) -> Bool {
        return textView.text.trimming().count + (text.trimming().count - range.length) <= 300
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderForTxtView
            textView.textColor = UIColor.lightGray
        }
    }
}
