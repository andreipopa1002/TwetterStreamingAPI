//
//  SessionDelegate.swift
//  Experiment2
//
//  Created by Andrei Popa on 17/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

final class SessionDelegate: NSObject {
    let completion: RequestCompletion
    let parser: ParserProtocol
    let serialization: JSONSerializationWrapperProtocol
    
    init(jsonSerialization: JSONSerializationWrapperProtocol =  JSONSerializationWrapper(), parser: ParserProtocol = Parser(), completion: @escaping RequestCompletion) {
        self.serialization = jsonSerialization
        self.completion = completion
        self.parser = parser
    }
}

extension SessionDelegate: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            completionHandler(
                Foundation.URLSession.AuthChallengeDisposition.useCredential,
                URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
            let json = try serialization.jsonObject(with: data, options: .allowFragments)
            guard let tweet = self.parser.parse(response: json) else { return }
            DispatchQueue.main.async {
                self.completion(.success(tweet))
            }
        } catch { return }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        guard let _ = response as? HTTPURLResponse else {
            DispatchQueue.main.async {
                self.completion(.failure(ErrorMessage(operationMessage:"didReceiveResponse is not NSHTTPURLResponse")))
            }
            
            return
        }
        
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        task.cancel()
        DispatchQueue.main.async {
            self.completion(.failure(ErrorMessage(operationMessage: "call failed with error: \(String(describing: error?.localizedDescription))")))
        }
    }
}
