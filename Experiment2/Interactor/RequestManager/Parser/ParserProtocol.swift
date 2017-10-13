//
//  ParserProtocol.swift
//  Experiment2
//
//  Created by Andrei Popa on 17/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

struct Tweet: Equatable {
    let name: String
    let screenName: String
    let tweetMessage: String
    
    public static func ==(lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.name == rhs.name &&
            lhs.screenName == rhs.screenName &&
            lhs.tweetMessage == rhs.tweetMessage
    }
}


protocol ParserProtocol {
    func parse(response: Any) -> Tweet?
}
