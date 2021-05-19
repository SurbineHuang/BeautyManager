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
    let name: String
    let id: String
    let status: String
    let expiryDate: TimeInterval
    let openedDate: TimeInterval
    let periodAfterOpening: TimeInterval
}

struct User {
    
    let id: String
    let appleId: String
    let name: String
    
}

struct Brand {
    
    let id: String
    let name: String
}

struct Type {
    
    let id: String
    let name: String
    
}

class ProductManager {
    
    static let shared = ProductManager()
    
    func getProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        
        var products: [Product] = []
        
        Firestore.firestore().collection("Products").getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
               }
            
            for document in querySnapshot!.documents {
                
                if let id = document.get("ID") as? String,
                   let name = document.get("name") as? String,
                   let status = document.get("status") as? String,
                   let expiryDate = document.get("expiryDate") as? TimeInterval,
                   let openedDate = document.get("openedDate") as? TimeInterval,
                   let periodAfterOpening = document.get("periodAfterOpening") as? TimeInterval {
                    
                    let product = Product(name: name, id: id, status: status, expiryDate: expiryDate, openedDate: openedDate, periodAfterOpening: periodAfterOpening)
                    
                    products.append(product)
                }                
            }
            
            completion(.success(products))
        }
    }
    
    func getBrand() {
        
        Firestore.firestore().collection("Users").document("k0QvqvGaG5CDTeRQtAKL").collection("Brand").getDocuments {
            (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                
                for document in querySnapshot.documents {
                    print(document.documentID)
                }
            }
        }
    }
    
    func getType() {
        
        Firestore.firestore().collection("Users").document("k0QvqvGaG5CDTeRQtAKL").collection("Type").getDocuments {
            (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                
                for document in querySnapshot.documents {
                    print(document.documentID)
                }
            }
        }
    }
    
    func addProduct(name: String, expiryDate: TimeInterval, openedDate: TimeInterval, periodAfterOpening: TimeInterval) {
        
        let products = Firestore.firestore().collection("Products")
        
        let document = products.document()
        
        let data: [String: Any] = [
            "ID": document.documentID,
            "name": name,
            "expiryDate": expiryDate,
            "openedDate": openedDate,
            "periodAfterOpening": periodAfterOpening,
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
    
    func addBrand(brand: String) {

        let brand = Firestore.firestore().collection("Users").document("k0QvqvGaG5CDTeRQtAKL").collection("Brand")

        let document = brand.document("nCOL06W911SbGQYtRDi8")
        
        let data: [String: Any] = [
            "ID": document.documentID,
            "name": brand
        ]
        
        document.setData(data)
    }
    
    func addType(type: String) {
        
        let type = Firestore.firestore().collection("Users").document("k0QvqvGaG5CDTeRQtAKL").collection("Type")
        
        let document = type.document()
        
        let data: [String: Any] = [
            "ID": document.documentID,
            "name": type
        ]
        
        document.setData(data)
    }
}
