//
//  Agent.swift
//  Agent
//
//  Created by Christoffer Hallas on 6/2/14.
//  Copyright (c) 2014 Christoffer Hallas. All rights reserved.
//

import Foundation
import UIKit

class Agent {
    
    typealias Headers = Dictionary<String, String>
    typealias Data = AnyObject!
    typealias Response = (NSHTTPURLResponse!, Data!, NSError!) -> Void
    
    /**
    * Members
    */
    
    var request: NSMutableURLRequest
    let queue = NSOperationQueue()
    
    /**
    * Initialize
    */
    
    init(method: String, url: String, headers: Headers?) {
        self.request = NSMutableURLRequest(URL: NSURL(string: url))
        self.request.HTTPMethod = method;
        if (headers != nil) {
            self.request.allHTTPHeaderFields = headers!
        }
    }
    
    /**
    * GET
    */
    
    class func get(url: String) -> Agent {
        return Agent(method: "GET", url: url, headers: nil)
    }
    
    class func get(url: String, headers: Headers) -> Agent {
        return Agent(method: "GET", url: url, headers: headers)
    }
    
    class func get(url: String, done: Response) -> Agent {
        return Agent.get(url).end(done)
    }
    
    class func get(url: String, headers: Headers, done: Response) -> Agent {
        return Agent.get(url, headers: headers).end(done)
    }
    
    /**
    * POST
    */
    
    class func post(url: String) -> Agent {
        return Agent(method: "POST", url: url, headers: nil)
    }
    
    class func post(url: String, headers: Headers) -> Agent {
        return Agent(method: "POST", url: url, headers: headers)
    }
    
    class func post(url: String, done: Response) -> Agent {
        return Agent.post(url).end(done)
    }
    
    class func post(url: String, headers: Headers, data: Data) -> Agent {
        return Agent.post(url, headers: headers).send(data)
    }
    
    class func post(url: String, data: Data) -> Agent {
        return Agent.post(url).send(data)
    }
    
    class func post(url: String, data: Data, done: Response) -> Agent {
        return Agent.post(url, data: data).send(data).end(done)
    }
    
    class func post(url: String, headers: Headers, data: Data, done: Response) -> Agent {
        return Agent.post(url, headers: headers, data: data).send(data).end(done)
    }
    
    /**
    * PUT
    */
    
    class func put(url: String) -> Agent {
        return Agent(method: "PUT", url: url, headers: nil)
    }
    
    class func put(url: String, headers: Headers) -> Agent {
        return Agent(method: "PUT", url: url, headers: headers)
    }
    
    class func put(url: String, done: Response) -> Agent {
        return Agent.put(url).end(done)
    }
    
    class func put(url: String, headers: Headers, data: Data) -> Agent {
        return Agent.put(url, headers: headers).send(data)
    }
    
    class func put(url: String, data: Data) -> Agent {
        return Agent.put(url).send(data)
    }
    
    class func put(url: String, data: Data, done: Response) -> Agent {
        return Agent.put(url, data: data).send(data).end(done)
    }
    
    class func put(url: String, headers: Headers, data: Data, done: Response) -> Agent {
        return Agent.put(url, headers: headers, data: data).send(data).end(done)
    }
    
    /**
    * DELETE
    */
    
    class func delete(url: String) -> Agent {
        return Agent(method: "DELETE", url: url, headers: nil)
    }
    
    class func delete(url: String, headers: Headers) -> Agent {
        return Agent(method: "DELETE", url: url, headers: headers)
    }
    
    class func delete(url: String, done: Response) -> Agent {
        return Agent.delete(url).end(done)
    }
    
    class func delete(url: String, headers: Headers, done: Response) -> Agent {
        return Agent.delete(url, headers: headers).end(done)
    }
    
    /**
    * Methods
    */
    
    func send(data: Data) -> Agent {
        var error: NSError?
        let json = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: &error)
        self.set("Content-Type", value: "application/json")
        self.request.HTTPBody = json
        return self
    }
    
    func attachImage(named: String, withBoundry: String = "---------------------------14737809831466499882746641449" ) -> Agent {
        let image = UIImage(named: named)
        let imageContent = UIImagePNGRepresentation(image)
        
        if let imageData = imageContent {
            // set Content-Type in HTTP header
            let boundaryConstant = withBoundry;
            self.request.addValue("multipart/form-data; boundary=\(boundaryConstant)", forHTTPHeaderField: "Content-Type")
            
            // create body
            var body = NSMutableData()
            body.appendData( ("--\(boundaryConstant)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData( ("Content-Disposition: attachment; name=\"file\"; filename=\"\(named).png\"\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData( ("Content-Type: application/octet-stream\r\n\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSData(data: imageData))
            body.appendData( ("\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData( ("--\(boundaryConstant)--\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            self.request.HTTPBody = body
        }
        return self
    }
    
    func set(header: String, value: String) -> Agent {
        self.request.setValue(value, forHTTPHeaderField: header)
        return self
    }
    
    func end(done: Response) -> Agent {
        let completion = { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let res = response as NSHTTPURLResponse!
            if (error != nil) {
                println(error)
                return
            }
            var error: NSError?
            var textData = NSString(data: data, encoding: NSUTF8StringEncoding)
            done(res, textData, error)
        }
        NSURLConnection.sendAsynchronousRequest(self.request, queue: self.queue, completionHandler: completion)
        return self
    }
    
}