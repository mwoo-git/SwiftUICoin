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
        case badURLResponse(url: URL, status: Int)
        case internalError429(url: URL)
        case serverError500(url: URL, status: Int)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url, status: let status):
                return "[🔥] Bad response [\(status)] form URL: \(url)"
            case .internalError429(url: let url):
                return "[🔥] Bad response [429] 요청이 너무 많습니다. form URL: \(url)"
            case .serverError500(url: let url, status: let status):
                return "[🔥] Bad response [\(status)] 서버 오류 form URL: \(url)"
            case .unknown:
                return "[⚠️] Unknown error occured"
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
                      switch (output.response as! HTTPURLResponse).statusCode {
                      case 429:
                          throw NetworkingError.internalError429(url: url)
                      case 500, 501, 502, 503:
                          throw NetworkingError.serverError500(url: url, status: (output.response as? HTTPURLResponse)?.statusCode ?? 0)
                      default:
                          throw NetworkingError.badURLResponse(url: url, status: (output.response as? HTTPURLResponse)?.statusCode ?? 0)
                      }
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
