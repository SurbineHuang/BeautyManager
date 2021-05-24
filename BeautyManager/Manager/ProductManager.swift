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
    let brandId: String
}

struct User {
    let id: String
    let appleId: String
    let name: String
}

struct Brand {
    var id: String
    var name: String
}

struct Type {
    let id: String
    let name: String
}

////////////////////////////////////////////

class ProductManager {
    
    static let shared = ProductManager()
    
    var brandList: [Brand] = []
}

// MARK: - User
extension ProductManager {
    
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
}

// MARK: - Product
extension ProductManager {
    
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
                   let brandId = document.get("brandId") as? String,
                   let status = document.get("status") as? String,
                   let expiryDate = document.get("expiryDate") as? TimeInterval,
                   let openedDate = document.get("openedDate") as? TimeInterval,
                   let periodAfterOpening = document.get("periodAfterOpening") as? TimeInterval {
                    
                    let product = Product(name: name, id: id, status: status, expiryDate: expiryDate, openedDate: openedDate, periodAfterOpening: periodAfterOpening, brandId: brandId)
                    
                    products.append(product)
                }
            }
            
            completion(.success(products))
        }
    }
    
    func addProduct(name: String, expiryDate: TimeInterval, openedDate: TimeInterval, periodAfterOpening: TimeInterval, brandName: String) {
        
        let products = Firestore.firestore().collection("Products")
        
        let document = products.document()
        
        let brandId = checkBrandExistAndGetBrandId(brandName: brandName)
        
        let data: [String: Any] = [
            "ID": document.documentID,
            "name": name,
            "expiryDate": expiryDate,
            "openedDate": openedDate,
            "periodAfterOpening": periodAfterOpening,
            "status": "待交換",
            "photo": "",
            "brandId": brandId
        ]
        
        document.setData(data)
    }
    
    func removeProduct(documentID: String) {
        
        Firestore.firestore().collection("Products").document(documentID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}

// MARK: - Brand
extension ProductManager {
    
    func getBrands(completion: @escaping (Result<[Brand], Error>) -> Void) {
        
        var brands: [Brand] = []
        
        Firestore.firestore().collection("Users").document("k0QvqvGaG5CDTeRQtAKL").collection("Brand").getDocuments { (querySnapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for document in querySnapshot!.documents {
                
                if let id = document.get("ID") as? String,
                   let brand = document.get("name") as? String {
                    
                    let brand = Brand(id: id, name: brand)
                    
                    brands.append(brand)
                }
            }
            
            self.brandList = brands
            
            completion(.success(brands))
        }
    }
    
    func addBrand(brandName: String) -> String {
        
        let brands = Firestore.firestore().collection("Users").document("k0QvqvGaG5CDTeRQtAKL").collection("Brand")
        
        let brandDocument = brands.document()
        
        brandDocument.setData(["ID": brandDocument.documentID, "name": brandName])
        
        return brandDocument.documentID
    }
    
    // TODO
    func checkBrandExistAndGetBrandId(brandName: String) -> String {
        
        let filteredBrands = self.brandList.filter { (brand) -> Bool in
            brandName == brand.name
        }
        
        if let theBrand = filteredBrands.first {
            return theBrand.id
        } else {
            let brandId = addBrand(brandName: brandName)
            return brandId
        }
        
        /*
        // if brandList has this brandName
        // 成立
        return brandList[0].id
        // else
        var brandId = addBrand(brandName: brandName)
        return brandId
         */
    }
    
    // 利用 brandID 去換回名稱
    func getBrandName(by brandID: String) -> String {
        
        let filteredBrands = self.brandList.filter { (brand) -> Bool in
            brand.id == brandID
        }
        
        if let brand = filteredBrands.first {
            // 有找到的話, 回傳品牌名稱
            return brand.name
        } else {
            // 沒有找到的話, 回傳一個空字串
            return ""
        }
    }
}

// MARK: - Type
extension ProductManager {
    
    func getTypes(completion: @escaping (Result<[Type], Error>) -> Void) {
        
        var types: [Type] = []
        
        Firestore.firestore().collection("Users").document("k0QvqvGaG5CDTeRQtAKL").collection("Type").getDocuments { (querySnapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for document in querySnapshot!.documents {
                
                if let id = document.get("ID") as? String,
                   let type = document.get("name") as? String {
                    
                    let type = Type(id: id, name: type)
                    
                    types.append(type)
                }
            }
            
            completion(.success(types))
        }
    }
    
    func addType(type: String) {
        
        let types = Firestore.firestore().collection("Users").document("k0QvqvGaG5CDTeRQtAKL").collection("Type")
        
        let document = types.document()
        
        let data: [String: Any] = [
            "ID": document.documentID,
            "name": type
        ]
        
        document.setData(data)
    }
}
