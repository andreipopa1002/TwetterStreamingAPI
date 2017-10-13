//
//  JSONSerializationWrapper.swift
//  Experiment2
//
//  Created by Andrei Popa on 20/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

final class JSONSerializationWrapper: JSONSerializationWrapperProtocol {
    
    func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: data, options: opt)
    }
}
