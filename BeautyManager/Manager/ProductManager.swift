//
//  ProductManager.swift
//  BeautyManager
//
//  Created by SurbineHuang on 17/5/21.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Product {
    
    let product: String
    let brand: String
    let type: String
    let id: String
    let expiryDate: Timestamp
    let openedDate: Timestamp
    let periodAfterOpening: Timestamp
    
}
class ProductManager {
    
    static let shared = ProductManager()
    
    func addProduct(product: String) {
        
        let products = Firestore.firestore().collection("Products")
        
        let document = products.document()
        
        let time = Timestamp.init(date: NSDate() as Date)
        
        let data: [String: Any] = [
            "ID": document.documentID,
            "name": product,
            "expiryDate": time,
            "openedDate": time,
            "periodAfterOpening": time,
            "status": "待交換",
            "photo": ""
        ]
        
        document.setData(data)
    }
    
    func addUser(ID: String, appleId: String, name: String) {
        
        let users = Firestore.firestore().collection("Users")
        
        let document = users.document()
        
        let data: [String: Any] = [
            "ID": document.documentID,
            "appleId": appleId,
            "name": name
        ]
        
        document.setData(data)
    }
    
    func setBrand(brand: String) {

        let brand = Firestore.firestore().collection("Users").document("k0QvqvGaG5CDTeRQtAKL").collection("Brand")

        let document = brand.document("Test")
        
        let data: [String: Any] = [
            "ID": document.documentID,
            "name": brand
        ]
        
        document.setData(data)
    }
    
    func setType(type: String) {
        
        let type = Firestore.firestore().collection("Users").document("k0QvqvGaG5CDTeRQtAKL").collection("Type")
        
        let document = type.document()
        
        let data: [String: Any] = [
            "ID": document.documentID,
            "name": type
        ]
        
        document.setData(data)
    }
    
}
