//
//  HomeViewController.swift
//  BlueDentist
//
//  Created by Michael Holt on 8/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController {
    class HomeView: UIView {
        lazy var tableView: UITableView = {
            let tableView = UITableView()
            return tableView
        }()
        lazy var stateLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            return label
        }()
        lazy var startButton: UIButton = {
            let button = UIButton()
            button.setTitle("Scan", for: UIControl.State.normal)
            button.setTitleColor(.blue, for: UIControl.State.normal)
            return button
        }()
        lazy var topStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.alignment = .fill
            stack.spacing = 8
            [
                stateLabel,
                startButton,
                ].forEach(stack.addArrangedSubview)
            return stack
        }()
        lazy var mainStack: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.alignment = .fill
            stack.distribution = .fill
            stack.spacing = 8
            [
                topStack,
                tableView,
                ].forEach(stack.addArrangedSubview)
            return stack
        }()
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
            addSubview(mainStack)
            NSLayoutConstraint.activate([
                mainStack.topAnchor.constraint(equalToSystemSpacingBelow: self.safeAreaLayoutGuide.topAnchor, multiplier: 1),
                self.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor),
                mainStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            ])
        }

        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    var contentView: HomeView { return view as! HomeView }

    var devices = [BluetoothDevice]()

    override func loadView() {
        view = HomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.tableView.register(DeviceCell.self, forCellReuseIdentifier: DeviceCell.reuseIdentifier)
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControl.Event.touchUpInside)
        updateUI()
    }

    lazy var manager = CBCentralManager(delegate: self, queue: nil)

    private func updateUI(state: CBManagerState? = nil) {
        let state = state ?? manager.state
        updateStateLabel(state: state, isScanning: manager.isScanning)
        updateStartButton(state: state, isScanning: manager.isScanning)
    }

    private func updateStartButton(state: CBManagerState, isScanning: Bool) {
        switch state {
        case .poweredOn: contentView.startButton.isEnabled = true
        default: contentView.startButton.isEnabled = false
        }

        if isScanning {
            contentView.startButton.setTitle("Stop", for: UIControl.State.normal)
        } else {
            contentView.startButton.setTitle("Scan", for: UIControl.State.normal)
        }
    }

    private func updateStateLabel(state: CBManagerState, isScanning: Bool) {
        if isScanning {
            contentView.stateLabel.text = "Scanning"
        } else {
            contentView.stateLabel.text = getStateString(state: state)
        }
    }

    private func getStateString(state: CBManagerState) -> String {
        switch state {
        case .poweredOff: return "Powered Off"
        case .poweredOn: return "Powered On"
        case .resetting: return "Resetting"
        case .unauthorized: return "Unauthorized"
        case .unknown: return "Unknown"
        case .unsupported: return "Unsupported"
        @unknown default:
            fatalError()
        }
    }


    @objc
    private func startButtonTouched() {
        if manager.isScanning {
            manager.stopScan()
        } else {
            if manager.state == .poweredOn {
                manager.scanForPeripherals(withServices: [], options: nil)
            }
        }
        updateUI()
    }
}

extension HomeViewController: UITableViewDataSource {
    class DeviceCell: UITableViewCell {
        static let reuseIdentifier = "DeviceCell"
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: DeviceCell.reuseIdentifier)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeviceCell.reuseIdentifier, for: indexPath) as! DeviceCell
        let device = devices[indexPath.row]
        let name = device.peripheral.name ?? "Unnamed Peripheral"
        cell.textLabel?.text = "\(name) (\(device.rssi))"
        return cell
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if manager.isScanning {
            manager.stopScan()
            updateUI()
        }
        let device = devices[indexPath.row]
        manager.connect(device.peripheral, options: nil)
    }

}

extension HomeViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        updateUI(state: central.state)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let rssi = Int(truncating: RSSI)
        print("\(peripheral.identifier) \(peripheral.name ?? "Unnamed Peripheral") \(rssi)")

        //addDevice
        devices.removeAll(where: {$0.identifier == peripheral.identifier})
        devices.append(BluetoothDevice(identifier: peripheral.identifier, peripheral: peripheral, advertizementData: advertisementData, rssi: rssi))
        devices.sort(by: { $0.rssi > $1.rssi })
        self.contentView.tableView.reloadData()
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect")
        let viewController = DeviceViewController()
        viewController.peripheral = peripheral
        navigationController?.pushViewController(viewController, animated: true)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        navigationController?.popViewController(animated: true)
    }
}

typealias JSON = [String: Any]

struct BluetoothDevice {
    let identifier: UUID
    let peripheral: CBPeripheral
    let advertizementData: JSON
    let rssi: Int
}


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
