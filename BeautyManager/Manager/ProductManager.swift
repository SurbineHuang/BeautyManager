//
//  ProductManager.swift
//  BeautyManager
//
//  Created by SurbineHuang on 17/5/21.
//

import Firebase
import FirebaseFirestore
import Foundation

struct Product {
    let name: String
    let id: String
    let status: String
    let expiryDate: TimeInterval
    let openedDate: TimeInterval
    let periodAfterOpening: TimeInterval
    let photo: String
    let brandId: String
    let typeId: String
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
    var typeList: [Type] = []
}

// MARK: - User
extension ProductManager {
    
    func addUser(appleId: String) {
        
        print("=== addUser")
        let users = Firestore.firestore().collection("Users")
        
        let document = users.document(appleId)
        
        let data: [String: Any] = [
            "appleId": appleId
        ]
        
        document.setData(data)
    }
}

// MARK: - Product
extension ProductManager {
    
    func getProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        var products: [Product] = []
        
        Firestore.firestore().collection("Products").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for document in querySnapshot!.documents {
                if let id = document.get("ID") as? String,
                   let name = document.get("name") as? String,
                   let brandId = document.get("brandId") as? String,
                   let typeId = document.get("typeId") as? String,
                   let status = document.get("status") as? String,
                   let photo = document.get("photo") as? String,
                   let expiryDate = document.get("expiryDate") as? TimeInterval,
                   let openedDate = document.get("openedDate") as? TimeInterval,
                   let periodAfterOpening = document.get("periodAfterOpening") as? TimeInterval {
                    let product = Product(name: name,
                                          id: id,
                                          status: status,
                                          expiryDate: expiryDate,
                                          openedDate: openedDate,
                                          periodAfterOpening: periodAfterOpening,
                                          photo: photo,
                                          brandId: brandId,
                                          typeId: typeId)
                    
                    products.append(product)
                }
            }
            
            completion(.success(products))
        }
    }
    
    // swiftlint:disable function_parameter_count
    func addProduct(name: String, expiryDate: TimeInterval, openedDate: TimeInterval, periodAfterOpening: TimeInterval, photoUrlString: String, brandName: String, typeName: String) {
        let products = Firestore.firestore().collection("Products")
        
        let document = products.document()
        
        let brandId = checkBrandExistAndGetBrandId(brandName: brandName)
        
        let typeId = checkBrandExistAndGetTypeId(typeName: typeName)
        
        let data: [String: Any] = [
            "ID": document.documentID,
            "name": name,
            "expiryDate": expiryDate,
            "openedDate": openedDate,
            "periodAfterOpening": periodAfterOpening,
            "status": "待交換",
            "photo": photoUrlString,
            "brandId": brandId,
            "typeId": typeId
        ]
        
        document.setData(data)
    }
    // swiftlint:ensable function_parameter_count

    func removeProduct(appleId: String) {
        Firestore.firestore().collection("Products").document(appleId).delete { err in
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
        
        if let appleId = UserDefaults.standard.string(forKey: "appleId") {
            
            Firestore.firestore().collection("Users").document(appleId).collection("Brand").getDocuments { querySnapshot, error in
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
    }
    
    func addBrand(brandName: String) -> String {
        
        if let appleId = UserDefaults.standard.string(forKey: "appleId") {
            
            let brands = Firestore.firestore().collection("Users").document(appleId).collection("Brand")
            let brandDocument = brands.document()
            brandDocument.setData(["ID": brandDocument.documentID, "name": brandName])
            
            return brandDocument.documentID
            
        } else {
            
            print("ERROR: func addBrand can't find appleId from userDefault")
            return ""
        }
    }
    
    func checkBrandExistAndGetBrandId(brandName: String) -> String {
        let filteredBrands = self.brandList.filter { brand -> Bool in
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
        let filteredBrands = self.brandList.filter { brand -> Bool in
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
        
        if let appleId = UserDefaults.standard.string(forKey: "appleId") {
            
            Firestore.firestore().collection("Users").document(appleId).collection("Type").getDocuments { querySnapshot, error in
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
                
                self.typeList = types
                completion(.success(types))
            }
           
        }
    }
    
    func addType(typeName: String) -> String {

        if let appleId = UserDefaults.standard.string(forKey: "appleId") {
            
            let types = Firestore.firestore().collection("Users").document(appleId).collection("Type")
            
            let typeDocument = types.document()
            
            typeDocument.setData(["ID": typeDocument.documentID, "name": typeName])
            
            return typeDocument.documentID
            
        } else {
            
            print("ERROR: func addType can't find appleId from userDefault")
            return ""
        }
    }
    
    func checkBrandExistAndGetTypeId(typeName: String) -> String {
        let filteredTypes = self.typeList.filter { type -> Bool in
            typeName == type.name
        }
        
        if let theType = filteredTypes.first {
            return theType.id
        } else {
            let typeId = addType(typeName: typeName)
            return typeId
        }
    }
    
    func getTypeName(by typeId: String) -> String {
        let filteredTypes = self.typeList.filter { type -> Bool in
            type.id == typeId
        }
        
        if let type = filteredTypes.first {
            // 有找到的話, 回傳品牌名稱
            return type.name
        } else {
            // 沒有找到的話, 回傳一個空字串
            return ""
        }
    }
}
