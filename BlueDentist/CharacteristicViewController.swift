//
//  CharacteristicViewController.swift
//  BlueDentist
//
//  Created by Michael Holt on 8/23/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import CoreBluetooth

class CharacteristicViewController: UITableViewController, CBPeripheralDelegate {
    var peripheral: CBPeripheral!
    var service: CBService!
    var characteristic: CBCharacteristic!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = characteristic.uuid.title
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: SubtitleCell.reuseIdentifier)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        peripheral.delegate = self
        peripheral.discoverDescriptors(for: characteristic)

        if characteristic.properties.contains(CBCharacteristicProperties.notify) {
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if characteristic.properties.contains(CBCharacteristicProperties.notify) {
            peripheral.setNotifyValue(false, for: characteristic)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristic.descriptors?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleCell.reuseIdentifier, for: indexPath) as! SubtitleCell
        let descriptor = characteristic.descriptors![indexPath.row]
        cell.textLabel?.text = descriptor.uuid.title
        cell.detailTextLabel?.text = String(describing: descriptor.value)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let descriptor = characteristic.descriptors![indexPath.row]
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
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        tableView.reloadData()
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        tableView.reloadData()
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        tableView.reloadData()
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        tableView.reloadData()
    }
}
