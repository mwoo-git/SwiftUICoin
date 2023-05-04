//
//  NetworkMornitor.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/15.
//

import Foundation
import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    
    @Published var isConnected: Bool = false
    @Published var showAlert: Bool = false
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                    if path.status == .satisfied {
                        withAnimation {
                            self?.isConnected = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                self?.showAlert = false
                            }
                        }
                    } else {
                        withAnimation {
                            self?.isConnected = false
                            self?.showAlert = true
                        }
                    }
            }
        }
        monitor.start(queue: queue)
    }
}
