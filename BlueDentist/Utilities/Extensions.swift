//
//  Extensions.swift
//  BlueDentist
//
//  Created by Michael Holt on 8/24/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import CoreBluetooth

extension CBUUID {
    var title: String {
        var title = self.description
        if (title.hasPrefix("Unknown")) {
            title = self.uuidString
        }
        return title
    }
}

extension Data {
    var hexString: String {
        var hex:String = ""
        for byte in self {
            hex += String(format: "%02X", byte)
        }
        return hex
    }
}
