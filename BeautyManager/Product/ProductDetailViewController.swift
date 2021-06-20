//
//  ProductViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 14/5/21.
//

import Firebase
import FirebaseStorage
import UIKit

class ProductDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var expiryTextField: UITextField!
    @IBOutlet weak var openedTextField: UITextField!
    @IBOutlet weak var periodTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()

    var productImage: UIImage?
    var productImageUrlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateFormatter.dateFormat = "yyyy.MM.dd"
        self.datePicker.minimumDate = Date()

        // 設定 datePicker 功能及外觀
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = NSLocale(
            localeIdentifier: "zh_TW") as Locale

        self.datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.backgroundColor = .white

        // 設定 textField 外觀
        self.expiryTextField.backgroundColor = .clear
        self.expiryTextField.borderStyle = .none
        self.expiryTextField.inputView = self.datePicker

        self.openedTextField.backgroundColor = .clear
        self.openedTextField.borderStyle = .none
        self.openedTextField.inputView = self.datePicker

        self.periodTextField.backgroundColor = .clear
        self.periodTextField.borderStyle = .none
        self.periodTextField.inputView = self.datePicker
        
        self.addButton.layer.shadowOpacity = 0.2
        self.addButton.layer.cornerRadius = 20
        self.photoButton.layer.cornerRadius = 10
        // 設定空白處點選結束
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)

        // 設定 nameTextField
        self.nameTextField.delegate = self

        self.nameTextField.clearButtonMode = .whileEditing
        self.typeTextField.clearButtonMode = .whileEditing
        self.brandTextField.clearButtonMode = .whileEditing
    }

    @objc func dateChanged(datePicker: UIDatePicker) {
        if self.expiryTextField.isFirstResponder {
            self.expiryTextField.text = self.dateFormatter.string(from: datePicker.date)
        } else if self.openedTextField.isFirstResponder {
            self.openedTextField.text = self.dateFormatter.string(from: datePicker.date)
        } else if self.periodTextField.isFirstResponder {
            self.periodTextField.text = self.dateFormatter.string(from: datePicker.date)
        }
    }

    @objc func viewTapped() {
        self.view.endEditing(true)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addTapped(_ sender: Any) {
       
        guard let name = self.nameTextField.text, !name.isEmpty else {
            
            return
        }

        guard let brand = self.brandTextField.text, !brand.isEmpty else {
            
            return
        }

        guard let type = self.typeTextField.text, !type.isEmpty else {
            
            return
        }

        guard let expiryDateStr = self.expiryTextField.text else {
            
            return
        }

        guard let expiryDate = self.dateFormatter.date(from: expiryDateStr) else {
            
            return
        }

        guard let openedDateStr = self.openedTextField.text else {
            
            return
        }

        guard let openedDate = self.dateFormatter.date(from: openedDateStr) else {
            
            return
        }

        guard let periodAfterOpeningStr = self.periodTextField.text else {
            
            return
        }

        guard let periodAfterOpening = self.dateFormatter.date(from: periodAfterOpeningStr) else {
            
            return
        }

        guard let imageUrlString = self.productImageUrlString else {
            
            return
        }
        
        ProductManager.shared.addProduct(name: name,
                                         expiryDate: expiryDate.timeIntervalSince1970,
                                         openedDate: openedDate.timeIntervalSince1970,
                                         periodAfterOpening: periodAfterOpening.timeIntervalSince1970,
                                         photoUrlString: imageUrlString,
                                         brandName: brand,
                                         typeName: type)
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - camera
extension ProductDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 從圖庫取得照片
    func photoPicker() {
        let photoController = UIImagePickerController()
        photoController.delegate = self
        photoController.sourceType = .photoLibrary
        present(photoController, animated: true, completion: nil)
    }

    func camera() {
        if !(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            // Device does not have camera
            return
        }

        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = .camera
        present(cameraController, animated: true, completion: nil)
    }

    @IBAction func takePhotoTapped(_ sender: Any) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "開啟相機拍照", style: .default) { _ in
            self.camera()
        }

        let  libraryAction = UIAlertAction(title: "從相簿選擇", style: .default) { _ in
            self.photoPicker()
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        controller.addAction(cameraAction)
        controller.addAction(libraryAction)
        controller.addAction(cancelAction)

        present(controller, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.productImage = info[.originalImage] as? UIImage
        self.photoButton.setImage(self.productImage, for: .normal)
        self.uploadImage()
        dismiss(animated: true, completion: nil)
    }

    func uploadImage() {
        // 自動產生 ID ，方便上傳命名
        let uuidStr = UUID().uuidString

        if let image = self.productImage,
           let imageData = image.jpegData(compressionQuality: 0.5) {
            let storageRef = Storage.storage().reference()
            let imageRef = storageRef.child("ProductImages").child("\(uuidStr).jpg")

            imageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let metadata = metadata else {
                    return
                }

                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                print("Image resize to \(size)")

                // You can also access to download URL after upload.
                imageRef.downloadURL { url, _ in
                    guard let downloadURL = url else {
                        return
                    }
                    self.productImageUrlString = downloadURL.absoluteString
                }
            }
        }
    }
}
