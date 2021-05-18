//
//  ProductViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 14/5/21.
//

import UIKit
import Firebase

class ProductViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var textField01: UITextField!
    @IBOutlet weak var textField02: UITextField!
    @IBOutlet weak var textField03: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneTapped(_ sender: Any) {
    }
    
    let datePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定 datePicker 功能及外觀
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = NSLocale(
            localeIdentifier: "zh_TW") as Locale
        
        self.datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        self.datePicker.preferredDatePickerStyle = .wheels
        
        // 設定 textField 外觀
        self.textField01.backgroundColor = .clear
        self.textField01.borderStyle = .none
        self.textField01.inputView = self.datePicker
        
        self.textField02.backgroundColor = .clear
        self.textField02.borderStyle = .none
        self.textField02.inputView = self.datePicker
        
        self.textField03.backgroundColor = .clear
        self.textField03.borderStyle = .none
        self.textField03.inputView = self.datePicker
        
        // 設定空白處點選結束
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        // 設定 productTextField
        self.productTextField.delegate = self
        
        self.productTextField.clearButtonMode = .whileEditing
        self.typeTextField.clearButtonMode = .whileEditing
        self.brandTextField.clearButtonMode = .whileEditing
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if self.textField01.isFirstResponder {
            self.textField01.text = dateFormatter.string(from: datePicker.date)
            
        } else if self.textField02.isFirstResponder {
            self.textField02.text = dateFormatter.string(from: datePicker.date)
            
        } else if self.textField03.isFirstResponder {
            self.textField03.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func viewTapped() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        guard let product = self.productTextField.text, !product.isEmpty else {
            
            print("product is empty")
            return
        }
        
        guard let brand = self.brandTextField.text, !brand.isEmpty else {
            
            print("brand is empty")
            return
        }
        
        guard let type = self.typeTextField.text, !type.isEmpty else {
            
            print("type is empty")
            return
        }
        
        ProductManager.shared.addProduct(product: product)
//        ProductManager.shared.setBrand(brand: brand)
//        ProductManager.shared.setType(type: type)
//        
        self.dismiss(animated: true, completion: nil)
    }
}
