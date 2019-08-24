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
                if let data = characteristic.value {
                    switch data[2] {
                    case 1:
                        //handle turn
                        let turn = data[3]
                        let other1 = data[4]
                        let other2 = data[5]
                        print("Turn \(turn)\t-\t\(other1) \(other2)")

                    case 3:
                        //handle gyro movement
        //                let count = Int(data[1])
        //                let final = data[count - 1]
        //                print(final)
                        break

                    default:
                        //handle everything else
                        print(data.hexString)

                    }

                    //if data.count > 8 { return }
        //            if let ascii = String(data: data, encoding: String.Encoding.ascii) {
        //                print("ASCII:\t" + ascii)
        //            }
                    //print("Hex: " + data.hexString)
        //            if data.count <= 8 {
        //                var decimal:Int64 = 0
        //                (data as NSData).getBytes(&decimal, length: data.count)
        //                print("Decimal:\t\(decimal)")
        //            }

                    //handle turn
                    //let turn = data[3]

                }
        tableView.reloadData()
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        tableView.reloadData()
    }
}
