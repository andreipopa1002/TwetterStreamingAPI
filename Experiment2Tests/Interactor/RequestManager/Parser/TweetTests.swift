//
//  TweetTests.swift
//  Experiment2
//
//  Created by Andrei Popa on 20/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import XCTest
@testable import Experiment2

class TweetTests: XCTestCase {
    
    func test_Parser_TweetsShouldBeEqual() {
        let tweet1 = Tweet(name: "Mihai", screenName: "The Brave", tweetMessage: "I will unite you!" )
        let tweet2 = Tweet(name: "Mihai", screenName: "The Brave", tweetMessage: "I will unite you!" )
        
        XCTAssertEqual(tweet1, tweet2)
    }
    
    func test_Parse_TweetsShouldNotBeEqual_NotEqualScreenName() {
        let tweet1 = Tweet(name: "Mihai", screenName: "The Brave", tweetMessage: "I will unite you!" )
        let tweet2 = Tweet(name: "Mihai", screenName: "Not so brave", tweetMessage: "I will unite you!" )
        
        XCTAssertNotEqual(tweet1, tweet2)
    }
    
    func test_Parse_TweetsShouldNotBeEqual_NotEqualName() {
        let tweet1 = Tweet(name: "Mihai", screenName: "The Brave", tweetMessage: "I will unite you!" )
        let tweet2 = Tweet(name: "Johny", screenName: "The Brave", tweetMessage: "I will unite you!" )
        
        XCTAssertNotEqual(tweet1, tweet2)
    }
    
    func test_Parse_TweetsShouldNotBeEqual_NotEqualTweetMessage() {
        let tweet1 = Tweet(name: "Mihai", screenName: "The Brave", tweetMessage: "I will unite you!" )
        let tweet2 = Tweet(name: "Mihai", screenName: "The Brave", tweetMessage: "I will go for a pint!" )
        
        XCTAssertNotEqual(tweet1, tweet2)
    }
}
