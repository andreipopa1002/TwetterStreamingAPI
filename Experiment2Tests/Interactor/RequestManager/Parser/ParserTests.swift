//
//  ParserTests.swift
//  Experiment2
//
//  Created by Andrei Popa on 17/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import XCTest
@testable import Experiment2

class ParserTests: XCTestCase {
    var parser: Parser!
    
    override func setUp() {
        super.setUp()
        
        parser = Parser()
    }
    
    override func tearDown() {
        parser = nil
        
        super.tearDown()
    }
    
    func test_Parse_WhenCalledWithArray_ShouldReturnNil() {
        XCTAssertNil(parser.parse(response: [""]))
    }
    
    func test_Parse_WhenCalledWithValidDictionary_ShouldReturnTweet() {
        let tweet = parser.parse(response: loadResponse(fileName: "ValidResponse"))
        
        XCTAssertNotNil(tweet)
        XCTAssertEqual(tweet?.name, "Jonathan Maskew")
        XCTAssertEqual(tweet?.screenName, "jonathanmaskew")
        XCTAssertEqual(tweet?.tweetMessage, "RT @BurfordCapital: Thanks @atlblog for the great article on the continued growth of #LitigationFinance: https://t.co/puEDvYvU7N")
    }
}

extension ParserTests {

    fileprivate func loadResponse(fileName: String) -> [String: Any] {
        var dictionary = [String: Any]()
        if let url = Bundle(for: ParserTests.self).url(forResource: fileName, withExtension: "json") {
            let data = try! Data(contentsOf: url)
            dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary
        }
        return dictionary
    }
}
