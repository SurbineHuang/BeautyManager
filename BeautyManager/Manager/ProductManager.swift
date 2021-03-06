//
//  ProductManager.swift
//  BeautyManager
//
//  Created by SurbineHuang on 17/5/21.
//

import Firebase
import FirebaseFirestore
import Foundation

struct Product: Codable {
    let name: String
    let id: String
    let status: String
    let expiryDate: TimeInterval
    let openedDate: TimeInterval
    let periodAfterOpening: TimeInterval
    let photo: String
    let brandId: String
    let typeId: String
    let ownerId: String
}

struct User: Codable {
    let id: String
    let appleId: String
    let name: String
}

struct Brand: Codable {
    var id: String
    var name: String
}

struct Type: Codable {
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
                   let ownerId = document.get("ownerId") as? String,
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
                                          typeId: typeId,
                                          ownerId: ownerId)
                    
                    if ownerId == UserDefaults.standard.string(forKey: "appleId") {
                        products.append(product)
                    }
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
        
        if let appleId = UserDefaults.standard.string(forKey: "appleId") {
    
            let data: [String: Any] = [
                "ID": document.documentID,
                "name": name,
                "expiryDate": expiryDate,
                "openedDate": openedDate,
                "periodAfterOpening": periodAfterOpening,
                "status": "normal",
                "photo": photoUrlString,
                "brandId": brandId,
                "typeId": typeId,
                "ownerId": appleId
            ]
            
            document.setData(data)
        }
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
    // ????????????????????????
    func changeProductStatus(appleId: String) {
        
        Firestore.firestore().collection("Products").document(appleId).updateData([
            "status": "pending"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func changeProductStatusToFinish(appleId: String) {
        
        Firestore.firestore().collection("Products").document(appleId).updateData([
            "status": "finished"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
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
         // ??????
         return brandList[0].id
         // else
         var brandId = addBrand(brandName: brandName)
         return brandId
         */
    }
    
    // ?????? brandID ???????????????
    func getBrandName(by brandID: String) -> String {
        let filteredBrands = self.brandList.filter { brand -> Bool in
            brand.id == brandID
        }
        
        if let brand = filteredBrands.first {
            // ???????????????, ??????????????????
            return brand.name
        } else {
            // ??????????????????, ?????????????????????
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
            // ???????????????, ??????????????????
            return type.name
        } else {
            // ??????????????????, ?????????????????????
            return ""
        }
    }
}
