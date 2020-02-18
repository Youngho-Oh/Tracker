//
//  QueryService.swift
//  Tracker
//
//  Created by Youngho Oh on 2020/02/12.
//  Copyright © 2020 Youngho Oh. All rights reserved.
//

import Foundation

//
// MARK: - Query Service
//

class QueryService {
    //
    // MARK: - Constants
    //
    let defaultSession = URLSession(configuration: .default)
    let TARGETURL = "wow88.tplinkdns.com:9090"
    //
    // MARK: - Variables And Properties
    //
    var dataTask: URLSessionDataTask?
    var errorMessage = ""

    func send(searchTerm: String){
        dataTask?.cancel()

        if var urlComponents = URLComponents(string: TARGETURL) {
            urlComponents.query = "category=gps&term=\(searchTerm)"
            
            guard let url = urlComponents.url else {
                dump("url is wrong")
                return
            }
            
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }

                if let error = error {
                    self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                    dump("qqqqqqqqqqqqqqqq")
                    dump(self?.errorMessage)
                }else if
                let data = data,
                let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    //CODE
                    dump("connection is success : 200")
                }
            }
        }
        
        dataTask?.resume()
    }
}
