//
//  AppAuthSwiftTests.swift
//  AppAuthSwiftTests
//
//  Created by Maciej Kujalowicz on 11/30/16.
//  Copyright © 2016 Google Inc. All rights reserved.
//

import XCTest

class AppAuthSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint:
            URL(string: "http://")!,
            tokenEndpoint:
            URL(string: "https://api.twitter.com/oauth2/token")!)
        let tokenRequest = OIDTokenRequest(
            configuration: serviceConfiguration,
            grantType: "client_credentials",
            authorizationCode: nil,
            redirectURL: URL(string: "redirectURI:/")!,
            clientID: "",
            clientSecret: "",
            scope: "",
            refreshToken: nil,
            codeVerifier: nil,
            additionalParameters: nil)
        // needs to unwrap tokenRequest
        guard let tokenRequestUnwrapped = tokenRequest else {
            return
        }
        let asyncExpectation = expectation(description: "waiting for token response")
        OIDAuthorizationService.perform(tokenRequestUnwrapped) { (response, error) in
            print("error: \(error)")
            XCTAssertNotNil(response)
            asyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error)
        }
    }
    
}
