//
//  CBCharacteristicPropertiesExtensions.swift
//  BlueDentist
//
//  Created by Michael Holt on 8/24/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import CoreBluetooth

extension CBCharacteristicProperties: CaseIterable {
    public static var allCases: [CBCharacteristicProperties] {
        return [
        CBCharacteristicProperties.broadcast,
        CBCharacteristicProperties.read,
        CBCharacteristicProperties.writeWithoutResponse,
        CBCharacteristicProperties.write,
        CBCharacteristicProperties.notify,
        CBCharacteristicProperties.indicate,
        CBCharacteristicProperties.authenticatedSignedWrites,
        CBCharacteristicProperties.extendedProperties,
        CBCharacteristicProperties.notifyEncryptionRequired,
        CBCharacteristicProperties.indicateEncryptionRequired,
        ]
    }

    static let propDict = [
    CBCharacteristicProperties.broadcast.rawValue: "broadcast",
    CBCharacteristicProperties.read.rawValue: "read",
    CBCharacteristicProperties.writeWithoutResponse.rawValue: "writeWithoutResponse",
    CBCharacteristicProperties.write.rawValue: "write",
    CBCharacteristicProperties.notify.rawValue: "notify",
    CBCharacteristicProperties.indicate.rawValue: "indicate",
    CBCharacteristicProperties.authenticatedSignedWrites.rawValue: "authenticatedSignedWrites",
    CBCharacteristicProperties.extendedProperties.rawValue: "extendedProperties",
    CBCharacteristicProperties.notifyEncryptionRequired.rawValue: "notifyEncryptionRequired",
    CBCharacteristicProperties.indicateEncryptionRequired.rawValue: "indicateEncryptionRequired",
    ]

    var members: [CBCharacteristicProperties] {
        return CBCharacteristicProperties.allCases.filter({ self.contains($0) })
    }
    var description: String {
        return self.members
            .compactMap({ return CBCharacteristicProperties.propDict[$0.rawValue] })
            .joined(separator: ", ")
    }
}
