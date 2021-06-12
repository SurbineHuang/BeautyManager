//
//  DataViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 11/6/21.
//

import UIKit
import Charts

class DataViewController: UIViewController {
    
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var typeSegmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.chartView.frame = CGRect(x: 20, y: 80, width: self.view.bounds.width, height: 250)
        self.view.addSubview(chartView)
        
    }
    
}
