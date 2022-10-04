//
//  NetworkingManager.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//  재사용 가능한 네트워킹 매니저
//  메모: 서버에서 문제가 발생했을 때 화면에 띄울 수 있도록 기능추가해야합니다.

import Foundation
import Combine

class NetWorkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response form URL: \(url)"
                // \(url )로 어떤 url에서 에러가 발생했는지 알 수 있습니다.
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode == 200 else {
                  if let response = output.response as? HTTPURLResponse {
                      print("StatusCode\(response.statusCode)")
                  }
                  throw NetworkingError.badURLResponse(url: url)
              }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
            debugPrint(error)
        }
    }
}
