//
//  JSInteropBenchmarksTests.swift
//  JSInteropBenchmarksTests
//
//  Created by chendo on 9/04/2016.
//  Copyright © 2016 Sproutcube. All rights reserved.
//

import XCTest
import WebKit
@testable import JSInteropBenchmarks

@objc protocol ElementJSExports : JSExport {
    var value : String { get set }
    
    func getString(string: String) -> AnyObject
    static func getString(string: String) -> AnyObject
    
    static func getObject() -> ElementJSExports
    
    static func allTheData() -> [[String: String]]
}

@objc class ElementJS : NSObject, ElementJSExports {
    dynamic var value : String
    static let data = [[String: String]](count: 1000, repeatedValue: ["foo": "bar"])
    
    init (value: String) {
        self.value = value
    }
    
    func getString(string: String) -> AnyObject {
        return string
    }
    
    class func getString(name: String) -> AnyObject {
        return name
    }
    
    class func getObject() -> ElementJSExports {
        let obj = ElementJS(value: "foo")
        return obj
    }
    
    class func allTheData() -> [[String : String]] {
        return data
    }
}

class JSContextBenchmarksTests: XCTestCase {
    let iterations = 1 * 1000
    var context = JSContext()
    
    override func setUp() {
        super.setUp()
        
        context = JSContext()
        context.exceptionHandler = { context, exception in
            XCTFail("JS Error: \(exception)")
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func go(block: () -> AnyObject) {
        print(block())
        for var i = 0; i < self.iterations; i = i + 1 {
            block()
        }
    }
    
    func testScalarReturn() {
        self.measureBlock { () -> Void in
            self.go {
                self.context.evaluateScript("1")
            }
        }
    }
    
    func testObjectReturn() {
        self.measureBlock { () -> Void in
            self.go {
                self.context.evaluateScript("var foo = {\"foo\": \"bar\"}; foo").toDictionary()
            }
        }
    }
    
    func testNativeCall() {
        let function: @convention(block) String -> String = { input in
            return input
        }
        context.setObject(unsafeBitCast(function, AnyObject.self), forKeyedSubscript: "foo")
        self.measureBlock { () -> Void in
            self.go {
                self.context.evaluateScript("foo('hello')")
            }
        }
    }

    func testStaticFuncExportCallScalarReturn() {
        context.setObject(ElementJS.self, forKeyedSubscript: "ElementJS")
        self.measureBlock { () -> Void in
            self.go {
                self.context.evaluateScript("ElementJS.getString('foo')")
            }
        }
    }
    
    func testStaticFuncExportCallObjReturn() {
        context.setObject(ElementJS.self, forKeyedSubscript: "ElementJS")
        self.measureBlock { () -> Void in
            self.go {
                self.context.evaluateScript("ElementJS.getObject()")
            }
        }
    }
    
    func testStaticFuncExportCallObjReturn2() {
        context.setObject(ElementJS.self, forKeyedSubscript: "ElementJS")
        self.measureBlock { () -> Void in
            self.go {
                self.context.evaluateScript("ElementJS.getObject().getString('foo')")
            }
        }
    }
    
    func testStaticFuncExportCallReturnAllTheData() {
        context.setObject(ElementJS.self, forKeyedSubscript: "ElementJS")
        self.measureBlock { () -> Void in
            self.go {
                self.context.evaluateScript("ElementJS.allTheData()")
            }
        }
    }

}

