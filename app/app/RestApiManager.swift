//
//  RestAPIManager.swift
//  hypewizard
//
//  Created by Konstantin Yurchenko on 11/07/16.
//  Copyright © 2016 Disruptive Widgets. All rights reserved.
//  http://www.disruptivewidgets.com
//

import Foundation
import UIKit

typealias ServiceResponse = (NSDictionary, NSError?) -> Void

public typealias CompletionCallback = (_ result: NSDictionary?, _ error: NSError?) -> Void

class RestAPIClient: NSObject {
    let app_delegate = UIApplication.shared.delegate as! AppDelegate
    
    static let sharedInstance = RestAPIClient()
    
    let base_url = "http://api.hypewizard.com" // ENDPOINT
    
    func fetch_network_list(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/api/network_list"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    // MARK: LESSONS
    
    func request_ticket(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/api/request_ticket"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    
    func submit_post_request(endpoint: String, parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            RestAPIClient.sharedInstance.HTTPPostJSON(url: endpoint, data:data as NSData) { (response, error) -> Void in
                onCompletion(response as NSDictionary)
            }
        } catch let myJSONError {
            print(myJSONError)
        }
    }
    
    func submit_put_request(endpoint: String, parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            RestAPIClient.sharedInstance.HTTPPutJSON(url: endpoint, data:data as NSData) { (response, error) -> Void in
                onCompletion(response as NSDictionary)
            }
        } catch let myJSONError {
            print(myJSONError)
        }
    }
    
    func submit_get_request(endpoint: String, parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            RestAPIClient.sharedInstance.HTTPGetJSON(url: endpoint, data:data as NSData) { (response, error) -> Void in
                onCompletion(response as NSDictionary)
            }
        } catch let myJSONError {
            print(myJSONError)
        }
    }
    
    func HTTPsendRequest(request: NSMutableURLRequest, onCompletion: @escaping ServiceResponse) {
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                print("responseObject = \(responseObject)")
                
                onCompletion(responseObject, error as NSError?)
                
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
                onCompletion([:], error)
            }
        })
        
        task.resume()
    }
    
    func HTTPPostJSON(url: String, data: NSData, onCompletion: @escaping ServiceResponse) {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
//        if !self.app_delegate.me.auth_token.isEmpty {
//            request.setValue(self.app_delegate.me.auth_token, forHTTPHeaderField: "Authorization")
//        }
        
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data as Data
        HTTPsendRequest(request: request, onCompletion: onCompletion)
    }
    
    func HTTPPutJSON(url: String, data: NSData, onCompletion: @escaping ServiceResponse) {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
//        request.setValue(self.app_delegate.me.auth_token, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "PUT"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data as Data
        HTTPsendRequest(request: request, onCompletion: onCompletion)
    }
    
    func HTTPGetJSON(url: String, data: NSData, onCompletion: @escaping ServiceResponse) {
        
        let requestURL = NSURL(string: "\(url)")!
        
        let request = NSMutableURLRequest(url: requestURL as URL)
        
//        request.setValue(self.app_delegate.me.auth_token, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        HTTPsendRequest(request: request, onCompletion: onCompletion)
    }
    
    func makeHTTPGetRequest(path: String, parameters: [String: AnyObject], onCompletion: @escaping ServiceResponse) {
        
        let parameterString = parameters.stringFromHttpParameters()
        
        let requestURL = NSURL(string:"\(path)?\(parameterString)")!
        let request = NSMutableURLRequest(url: requestURL as URL)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                print("responseObject = \(responseObject)")
                
                onCompletion(responseObject, error as NSError?)
                
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
                onCompletion([:], error)
            }
        })
        task.resume()
    }
}
extension String {
    
    /// Percent escape value to be added to a URL query value as specified in RFC 3986
    ///
    /// This percent-escapes all characters besize the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Return precent escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters:characterSet as CharacterSet)
    }
}
extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}
