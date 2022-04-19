//
//  APIManager.swift
//  Tradelize
//
//  Created by Иван Викторович on 14.04.2021.
//

import UIKit
import Combine

class APIManager {
    
    static let shared = APIManager()
    
    private init() {}
    
//    private func createPostRequest<Request: RequestInterface, ResponseType: Codable>(url: URL?, request: Request, shouldUsePreloader: Bool = false) -> AnyPublisher<BaseResponse<ResponseType>, Never> {
//        guard let url = url else { return Just(BaseResponse<ResponseType>()).eraseToAnyPublisher() }
//        print("URL: -", url)
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.httpBody = request.mapToJSONData()
//        if shouldUsePreloader {
//            preloader.show()
//        }
//        return URLSession.shared.dataTaskPublisher(for: urlRequest)
//            .map({
//                DispatchQueue.main.async {
//                    preloader.hide()
//                }
//                return $0.data
//            })
//            .decode(type: BaseResponse<ResponseType>.self, decoder: JSONDecoder())
//            .catch({ error in
//                return Just(BaseResponse<ResponseType>()).eraseToAnyPublisher()
//            })
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
    
    func createGetRequest<ResponseType: Decodable>(url: URL?, header: [String:String?]?) -> AnyPublisher<ResponseType?, Never> {
        guard var url = url else { return Just(nil).eraseToAnyPublisher() }
        print("URL: -", url)
        if let header = header {
            var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: true)
            urlComp?.queryItems = header.map({ URLQueryItem(name: $0, value: $1) })
            
            guard let resultURL = urlComp?.url else { return Just(nil).eraseToAnyPublisher() }
            url = resultURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map({ (response) -> Data in return response.data })
            .decode(type: ResponseType?.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .catch({ _ in Just(nil).eraseToAnyPublisher() })
            .eraseToAnyPublisher()
    }
    
    
    
}
