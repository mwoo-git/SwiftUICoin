//
//  UpbitWebSocketService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/07.
//

import Foundation
import Combine
import Starscream


class UpbitWebSocketService: NSObject, URLSessionWebSocketDelegate {
    
    @Published var tickers = [UpbitTicker]()
    
    private var webSocket: URLSessionWebSocketTask?
    
    private var markets = [UpbitCoin]()
    
    func connect(coins: [UpbitCoin]) {
        self.markets = coins
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string:"wss://api.upbit.com/websocket/v1")!
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
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
    
    func close() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
    }
    
    func send() {
        let codes = markets.map { $0.market }.joined(separator: ",")
        let message = "{\"type\":\"ticker\",\"codes\":[\"\(codes)\"]}"
        webSocket?.send(.string(message), completionHandler: { error in
            if let error = error {
                print("Upbit send error: \(error.localizedDescription)")
            }
        })
    }
    
    func receive() {
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("데이터 받았습니다. \(data)")
                    let jsonData = data
                    let decoder = JSONDecoder()
                    do {
                        let tickers = try decoder.decode([UpbitTicker].self, from: jsonData)
                        DispatchQueue.main.async {
                            self?.tickers = tickers
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                case .string(let message):
                    break
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Upbit Receive error: \(error.localizedDescription)")
            }
            self?.receive()
        })
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("연결 완료")
        ping()
        receive()
        send()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("연결 끊김")
    }
}
