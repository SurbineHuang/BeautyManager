//
//  MyListVCTest.swift
//  BeautyManagerTests
//
//  Created by SurbineHuang on 21/6/21.
//

import XCTest
@testable import BeautyManager

class MyListVCTest: XCTestCase {
    
    var myListVC: MyListViewController?
    
    override func setUp() {

        self.myListVC = MyListViewController()// 只能在測試使用
        // 只是要測試，不需要而外生成 storyboard
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        self.myListVC = storyboard.instantiateViewController(withIdentifier: "MyListViewController") as? MyListViewController
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
 
    // NOTE: 測試的第一種方式 XCTAssertEqual, 判斷括弧內前後兩個值有沒有相同
    func testCase01() {
        
        let testItem01 = "123"
        XCTAssertEqual(testItem01, "123")
        
//        let testItem02 = "456"
//        XCTAssertEqual(testItem02, "123")
    }
    
    // NOTE: 測試的第二種方式 XCTAssert, 判斷括弧內的值 是否為 true
    func testCase02() {
        
//        let testItem01 = false
//        XCTAssert(testItem01)

//        let testItem02 = true
//        XCTAssert(testItem02)
        
//        let testItem03 = 200
//        XCTAssert(testItem03 == 200)
    }
    
    func testConvertDateToString() {
        
        let dateString = myListVC?.convertDateToString(expiryDate: 1624234883)
        XCTAssertEqual(dateString, "2021.06.21")
    }
}
