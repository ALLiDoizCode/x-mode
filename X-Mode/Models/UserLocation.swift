//
//  UserLocation.swift
//  X-Mode
//
//  Created by Green, Jonathan on 7/17/18.
//  Copyright © 2018 Green, Jonathan. All rights reserved.
//

import Foundation

struct UserLocation:Codable {
    var lat:String?
    var long:String?
    var id:String?
    let jsonEncoder = JSONEncoder()
    
    private enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case long = "long"
        case id = "id"
    }
    
    func encode() -> Data {
        let jsonData = try! jsonEncoder.encode(self)
        return jsonData
    }
    
    func decode(jsonString:String) -> UserLocation {
        let user = try! JSONDecoder().decode(UserLocation.self, from: jsonString.data(using: .utf8)!)
        return user
    }
}
