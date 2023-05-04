//
//  UpbitWebSocketService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/07.
//

import Foundation
import Combine

class UpbitWebSocketService: NSObject {
    
    static let shared = UpbitWebSocketService()
    
    private override init() {}
    
    @Published var isConnected = false
    
    let tickerDictionarySubject = CurrentValueSubject<[String: UpbitTicker], Never>([:])
    var tickerDictionary: [String: UpbitTicker] { tickerDictionarySubject.value }
    
    var codes: [String]? 
    
    private var webSocket: URLSessionWebSocketTask?
    
    func connect(withCodes codes: [String]) {
        self.codes = codes
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string:"wss://api.upbit.com/websocket/v1")!
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
    }
    
    func connect() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string:"wss://api.upbit.com/websocket/v1")!
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
    }
    
    func send() {
        guard let codes = codes else { return }
        let markets = codes.joined(separator: ",")
        let message = """
        [{"ticket":"bw"},{"type":"ticker","codes":[\(markets)],"isOnlyRealtime":"true"},{"format":"SIMPLE"}]
        """
        webSocket?.send(.string(message), completionHandler: { error in
            if let error = error {
                print("Upbit send error: \(error.localizedDescription)")
            }
        })
        print(message)
    }
    
    func ping() {
        let timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] timer in
            self?.webSocket?.sendPing(pongReceiveHandler: { error in
                if let error = error {
                    print("Upbit ping error: \(error.localizedDescription)")
                }
            })
        }
        timer.fire()
    }
    
    private func receive() {
        webSocket?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text message: \(text)")
                    if let data = text.data(using: .utf8) {
                        self.onReceiveData(data)
                    }
                case .data(let data):
                    print("Received binary message: \(data)")
                    self.onReceiveData(data)
                default: break
                }
                self.receive()
                
            case .failure(let error):
                print("Failed to receive message: \(error.localizedDescription)")
            }
        }
    }
    
    private func onReceiveData(_ data: Data) {
        DispatchQueue.global(qos: .background).async {
            guard let ticker = try? JSONDecoder().decode(UpbitTicker.self, from: data) else {
                return print("UpbitTicker 객체 생성 에러")
            }
            let newDictionary = [ticker.market: ticker]
            let mergedDictionary = self.tickerDictionary.merging(newDictionary) { $1 }
            self.tickerDictionarySubject.send(mergedDictionary)
        }
    }
    
    func close() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
    }
}

// MARK: - URLSessionWebSocketDelegate

extension UpbitWebSocketService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("UPbit websocket connection opened.")
        isConnected = true
        send()
        receive()
        ping()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("UPbit websocket connection closed.")
        isConnected = false
    }
}