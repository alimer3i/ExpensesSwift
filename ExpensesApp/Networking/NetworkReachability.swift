//
//  NetworkReachability.swift
//  RBT
//
//  Created by User on 22/07/2021.
//

import UIKit
import Alamofire

class NetworkDisableUIAlert: UIAlertController{}

class NetworkReachability {
    
    static let shared = NetworkReachability()
    static var isReachable = false
    
    private var currentVc: UIViewController?
    
    private let offlineAlertController: NetworkDisableUIAlert = {
        NetworkDisableUIAlert(title: "No Network", message: "Please connect to network and try again", preferredStyle: .alert)
    }()
    
    private func showOfflineAlert() {
        NetworkReachability.isReachable = false
        NotificationCenter.default.post(name: .internetConnectionLost, object: nil)
        
        currentVc = UIApplication.getTopViewController()
        guard let currentVc, currentVc.isViewLoaded && currentVc.view.window != nil else {
            self.currentVc?.present(offlineAlertController, animated: true, completion: nil)
            return
        }
    }
    
    func dismissOfflineAlert() {
        NetworkReachability.isReachable = true
        NotificationCenter.default.post(name: .internetConnectionBack, object: nil)
        if let strongVc = currentVc {
            strongVc.dismiss(animated: true, completion: nil)
        }
    }
    
    private let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    
    private func checkNetworkStatus(status: NetworkReachabilityManager.NetworkReachabilityStatus){
        switch status {
        case .notReachable:
            self.showOfflineAlert()
        case .reachable(.cellular):
            self.dismissOfflineAlert()
        case .reachable(.ethernetOrWiFi):
            self.dismissOfflineAlert()
        case .unknown:
            self.showOfflineAlert()
            print("Unknown network state")
        }
    }
    
    func startNetworkMonitoring() {
        reachabilityManager?.startListening { status in
            self.checkNetworkStatus(status: status)
        }
    }
    func recheckConnection(){
        checkNetworkStatus(status:reachabilityManager?.status ?? .reachable(.cellular))
        
    }
}

