//
//  Interacter.swift
//  X-Mode
//
//  Created by Green, Jonathan on 7/17/18.
//  Copyright © 2018 Green, Jonathan. All rights reserved.
//

import Foundation

protocol InteracterDelegate {
    func updateUI(user:UserLocation)
}

class Interacter {
    var delegate:InteracterDelegate?
    var client = SocketClient()
    func doSomeWork() {
        client.startSocket(delegate:delegate)
    }
}
