//
//  DataViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 11/6/21.
//

import UIKit
import Charts
import NVActivityIndicatorView

class DataViewController: UIViewController {
    
    enum DataType: Int {
        case brands = 0
        case types = 1
    }
    
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var typeSegmented: UISegmentedControl!
    
    let activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 40),
                                               type: .ballPulse,
                                               color: .brown)
    
    var currentType: DataType = .brands
    var products: [Product] = []
    var brandDatas: [(name: String, value: Double)] = []
    var typeDatas: [(name: String, value: Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chartView.noDataText = ""
        
        self.view.addSubview(activityView)
        self.activityView.center = self.view.center
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadProducts()
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == DataType.brands.rawValue {
            self.setChart(datas: self.brandDatas)
            
        } else if sender.selectedSegmentIndex == DataType.types.rawValue {
            self.setChart(datas: self.typeDatas)
        }
    }

    func loadProducts() {

        self.activityView.startAnimating()
        
        ProductManager.shared.getProducts { [weak self] result in

            guard let weakSelf = self else {
                return
            }
            
            switch result {
            case .success(let products):
                weakSelf.products = products
                weakSelf.brandDatas = weakSelf.filterBrands(from: products)
                weakSelf.typeDatas = weakSelf.filterTypes(from: products)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    
                    self?.activityView.stopAnimating()
                    
                    if weakSelf.currentType == .brands {
                        weakSelf.setChart(datas: weakSelf.brandDatas)
                    } else {
                        weakSelf.setChart(datas: weakSelf.typeDatas)
                    }
                }
                
            case .failure(let error):
                print("loadProducts.failure: \(error)")
            }
        }
    }
    
    // ?????? product ??????????????????
    func filterBrands(from products: [Product]) -> [(name: String, value: Double)] {
        
        // ??????????????????????????????, ???????????? dictionary, key ??? brandId, value ?????????
        // countsDict = ["brandId" : countNumber]
        let countsDict = products.reduce(into: [:]) { (counts, product) in
            counts[product.brandId, default: 0] += 1
        }
        
        let total = products.count
        
        var datas: [(name: String, value: Double)] = []
        
        countsDict.forEach { (key, value) in
            let name = ProductManager.shared.getBrandName(by: key)
            let percent = (Double(value) / Double(total)) * 100
            datas.append((name, percent))
        }
        
        return datas
    }
    
    func filterTypes(from products: [Product]) -> [(name: String, value: Double)] {
        
        // ??????????????????????????????, ???????????? dictionary, key ??? typeId, value ?????????
        // countsDict = ["typeId" : countNumber]
        let countsDict = products.reduce(into: [:]) { (counts, product) in
            counts[product.typeId, default: 0] += 1
        }
        
        let total = products.count
        
        var datas: [(name: String, value: Double)] = []
        
        countsDict.forEach { (key, value) in
            let name = ProductManager.shared.getTypeName(by: key)
            let percent = (Double(value) / Double(total)) * 100
            datas.append((name, percent))
        }
        
        return datas
    }
    
    func setChart(datas: [(name: String, value: Double)]) {
        
        var pieChartDataEntries: [PieChartDataEntry] = []
        
        for data in datas {
            let entry = PieChartDataEntry(value: data.value, label: data.name, icon: nil, data: nil)
            pieChartDataEntries.append(entry)
        }
        
        let set = PieChartDataSet(entries: pieChartDataEntries, label: "")
        
        // ??????????????????
        set.colors = self.createColors(number: datas.count)
        
        // ?????????????????????
        set.selectionShift = 0
        
        // ??????????????????
        set.sliceSpace = 2
        
        // ???????????????
        let data = PieChartData(dataSet: set)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        self.chartView.data = data
    }
 
    func createColors(number: Int) -> [UIColor] {
        
        let defaultColors = [UIColor.RGBA(r: 71, g: 44, b: 27),
                             UIColor.RGBA(r: 122, g: 158, b: 126),
                             UIColor.RGBA(r: 164, g: 119, b: 139),
                             UIColor.RGBA(r: 186, g: 110, b: 110),
                             UIColor.RGBA(r: 83, g: 104, b: 126),
                             UIColor.RGBA(r: 137, g: 96, b: 142),
                             UIColor.RGBA(r: 119, g: 175, b: 156),
                             UIColor.RGBA(r: 0, g: 126, b: 167),
                             UIColor.RGBA(r: 211, g: 82, b: 105),
                             UIColor.RGBA(r: 174, g: 132, b: 126)]
        
        var result: [UIColor] = []
        
        // ??????????????????????????????, ????????????????????????
        for index in 0..<number {
            if index < 10 {
                result.append(defaultColors[index])
            } else {
                result.append(UIColor.random)
            }
        }
        
        return result
    }
}
