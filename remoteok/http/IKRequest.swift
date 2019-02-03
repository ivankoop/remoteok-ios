//
//  IKRequest.swift
//  remoteok
//
//  Created by ivan koop on 2/3/19.
//  Copyright © 2019 vikm. All rights reserved.
//

import Foundation


class IKRequest: NSObject {
    
    static let BASE_URL = "https://remoteok.io/"
    static let API_VERSION = "api"
    
    static func request(endpoint : String, post : [String : String]?,  completionHandler: @escaping (_ objectOrErrorAsString : Any?, _ status_code: Int) -> Void) {
        
        let url = BASE_URL + API_VERSION + endpoint;
        
        print("Request --> \(url)");
        
        var status_code = 500;
        
        if let url = URL(string: url) {
            let session = URLSession.shared;
            var request = URLRequest(url: url as URL);
            if let post = post {
                var postString = "";
                for key in post.keys {
                    postString += "&" + key + "=" + post[key]!;
                }
                request.httpMethod = "POST";
                request.httpBody = postString.data(using: String.Encoding.utf8);
            }
            
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse {
                    status_code = httpResponse.statusCode
                    print("statusCode: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    if let error = error {
                        DispatchQueue.main.async {
                            NSLog(error.localizedDescription);
                            completionHandler(error.localizedDescription,status_code);
                        }
                    } else {
                        DispatchQueue.main.async {
                            completionHandler("No se pudieron interpretar los datos",status_code);
                            NSLog("No se pudieron interpretar los datos");
                        }
                    }
                    return;
                }
                
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                    DispatchQueue.main.async {
                        NSLog("No se pudieron interpretar los datos");
                        completionHandler("No se pudieron interpretar los datos",status_code);
                    }
                    return;
                }
                
                DispatchQueue.main.async {
                    completionHandler(jsonObject,status_code);
                }
                
            }).resume();
            
        } else {
            NSLog("No se pudieron interpretar los datos");
            completionHandler("No se pudieron interpretar los datos",status_code);
        }
        
    }
    
}
