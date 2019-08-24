//
//  ServiceViewController.swift
//  BlueDentist
//
//  Created by Michael Holt on 8/23/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import CoreBluetooth

class ServiceViewController: UITableViewController, CBPeripheralDelegate {
    var peripheral: CBPeripheral!
    var service: CBService!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = service.uuid.title
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: SubtitleCell.reuseIdentifier)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        peripheral.delegate = self
        peripheral.discoverIncludedServices(nil, for: service)
        peripheral.discoverCharacteristics(nil, for: service)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Included Services"
        case 1: return "Characteristics"
        default: fatalError()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return service.includedServices?.count ?? 0
        case 1: return service.characteristics?.count ?? 0
        default: fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleCell.reuseIdentifier, for: indexPath) as! SubtitleCell
        switch indexPath.section {
        case 0:
            let includedService = service.includedServices![indexPath.row]
            cell.textLabel?.text = "\(includedService.uuid.title)"
            cell.detailTextLabel?.text = nil
        case 1:
            let characteristic = service.characteristics![indexPath.row]
            cell.textLabel?.text = "\(characteristic.uuid.title)"
            cell.detailTextLabel?.text = "\(characteristic.properties.description)"
        default:
            fatalError()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let includedService = service.includedServices![indexPath.row]
            let viewController = ServiceViewController()
            viewController.peripheral = peripheral
            viewController.service = includedService
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let characteristic = service.characteristics![indexPath.row]
            let viewController = CharacteristicViewController()
            viewController.peripheral = peripheral
            viewController.service = service
            viewController.characteristic = characteristic
            navigationController?.pushViewController(viewController, animated: true)
        default:
            fatalError()
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        tableView.reloadData()
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        tableView.reloadData()
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        tableView.reloadData()
    }
}

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
