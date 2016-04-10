//
//  WKWebviewBenchmarksTests.swift
//  JSInteropBenchmarks
//
//  Created by Tate Johnson on 13/04/2016.
//  Copyright © 2016 Sproutcube. All rights reserved.
//

import XCTest
import WebKit

class WebviewSandbox: NSObject, WKNavigationDelegate {
	typealias ReadyHandler = (() -> Void)

	private let webView: WKWebView
	private var readyHandler: ReadyHandler?

	override init() {
		webView = WKWebView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
		super.init()
		webView.navigationDelegate = self
	}

	func loadHTMLString(HTMLString: String, readyHandler: ReadyHandler) {
		self.readyHandler = readyHandler
		webView.loadHTMLString(HTMLString, baseURL: nil)
	}

	func evaluateJavaScript(javaScriptString: String, completionHandler: ((AnyObject?, NSError?) -> Void)?) {
		webView.evaluateJavaScript(javaScriptString, completionHandler: completionHandler)
	}

	// MARK: WKNavigationDelegate

	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		readyHandler?()
	}
}

class WKWebviewBenchmarksTests: XCTestCase {
	let sandbox = WebviewSandbox()

	func testScalarReturn() {
		measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: false) {
			let expectation = self.expectationWithDescription("")

			let HTMLString =
				"<script type=\"text/javascript\">" +
					"function scalarReturn() { return 1 };" +
				"</script>"
			self.sandbox.loadHTMLString(HTMLString) {
				self.startMeasuring()

				for i in 0 ... 1000 {
					self.sandbox.evaluateJavaScript("scalarReturn();", completionHandler: { (value, error) in
						if i == 1000 {
							expectation.fulfill()
						}
					})
				}
			}

			self.waitForExpectationsWithTimeout(5.0, handler: { (error) in
				self.stopMeasuring()
			})
		}
	}
}
