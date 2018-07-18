//
//  Helper.swift
//  X-Mode
//
//  Created by Green, Jonathan on 7/17/18.
//  Copyright © 2018 Green, Jonathan. All rights reserved.
//

import Foundation

protocol Stringfy {}

extension Stringfy {
    func toString(data:Data) -> String {
        return String(data:data, encoding: .utf8)!
    }
}
extension Data:Stringfy {}
