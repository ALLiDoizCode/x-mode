//
//  socket.swift
//  X-Mode
//
//  Created by Green, Jonathan on 7/17/18.
//  Copyright © 2018 Green, Jonathan. All rights reserved.
//

import Foundation
import SwiftWebSocket

class SocketClient {
    var sock:WebSocket?
    func startSocket(delegate:InteracterDelegate?){
        let ws = WebSocket("ws://x-mode.herokuapp.com/ws")
        
        ws.event.open = {
            self.sock = ws
            print("opened")
            
        }
        ws.event.close = { code, reason, clean in
            print("close")
        }
        ws.event.error = { error in
            print("error \(error)")
        }
        ws.event.message = { message in
            if let text = message as? String {
                if let delegate = delegate {
                    let user = UserLocation().decode(jsonString: text)
                    delegate.updateUI(user: user)
                }
            }
        }
    }
}
