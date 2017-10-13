//
//  Parser.swift
//  Experiment2
//
//  Created by Andrei Popa on 17/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

struct Parser: ParserProtocol {
    private struct Constants {
        static let text = "text"
        static let user = "user"
        static let name = "name"
        static let screenName = "screen_name"
    }
    
    func parse(response: Any) -> Tweet? {
        guard let reseponseAsDictionary = response as? [String: Any],
            let text = reseponseAsDictionary[Constants.text] as? String,
            let user = reseponseAsDictionary[Constants.user] as? [String: Any],
            let name = user[Constants.name] as? String,
            let screenName = user[Constants.screenName] as? String else {
                return nil
        }
        return Tweet(name: name, screenName: screenName, tweetMessage: text)
    }
}
