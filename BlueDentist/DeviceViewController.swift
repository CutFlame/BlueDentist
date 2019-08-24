//
//  DeviceViewController.swift
//  BlueDentist
//
//  Created by Michael Holt on 8/23/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceViewController: UITableViewController, CBPeripheralDelegate {
    var peripheral: CBPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = peripheral.name ?? "Unnamed"
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: SubtitleCell.reuseIdentifier)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheral.services?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleCell.reuseIdentifier, for: indexPath) as! SubtitleCell
        let service = peripheral.services![indexPath.row]
        cell.textLabel?.text = "\(service.uuid.title)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = peripheral.services![indexPath.row]
        let viewController = ServiceViewController()
        viewController.peripheral = peripheral
        viewController.service = service
        navigationController?.pushViewController(viewController, animated: true)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        tableView.reloadData()
    }
}
