//
//  NeworkController.swift
//  Tracker
//
//  Created by Youngho Oh on 2020/02/12.
//  Copyright © 2020 Youngho Oh. All rights reserved.
//

import Foundation

class NetworkController{
//    let url = "wow88.tplinkdns.com"
    var BG_NAME_NETWORK_TASK = "com.youngho02.Tracker.bgnetworksession"
    
    func RecvData(resource: String){
        //CODE
//        let defaultSession = URLSession(configuration: .default)
        let defaultSession = URLSession(configuration: .background(withIdentifier: BG_NAME_NETWORK_TASK))
        
        guard let url = URL(string: "\(resource)") else {
            print("URL is nil")
            return
        }

        let request = URLRequest(url: url)
        
        let dataTask = defaultSession.dataTask(with: request){ (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
        }
        
        dataTask.resume()
    }
}
