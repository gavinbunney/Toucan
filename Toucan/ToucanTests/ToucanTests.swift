//
//  ToucanTests.swift
//  ToucanTests
//
//  Created by Bunney Apps on 12/08/2014.
//  Copyright (c) 2014 Bunney Apps. All rights reserved.
//

import UIKit
import XCTest

class ToucanTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
        
        //
        //XCTAssertNotNil(portrait, "SHould be set")
        
        let portrait = UIImage(named: "Portrait.jpg")
        let size = portrait.size
        print("size: \(size)")
//        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("Portrait", withExtension: "jpg"))

        XCTAssert(true, "Pass")
        XCTAssertNotNil(portrait, "Should be set")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
