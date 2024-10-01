//
//  APICaller.swift
//  NewsApp
//
//  Created by Akhil Thata on 9/19/24.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    struct Constants {
        private static let apiKey: String = "8dfb06d7c4a64acda8413848057b6921";
        static let topHeadlinesURL: URL? = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        // Add other HTTP methods as needed
    }
    
    private init() {}
    
    enum APIError: Error {
        case failedToGetData
    }
    
    public func fetchData<T: Decodable>(from url: URL?, responseType: T.Type, requestType: HTTPMethod, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(APIError.failedToGetData))
            return
        }
        
        createRequest(with: url, type: requestType) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    
                    if (responseType == String.self) {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        print(json)
                    }
                    
                    let result = try JSONDecoder().decode(responseType, from: data)
                    /*if (responseType == SearchResultResponse.self) {
                        print(result)
                    }*/
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    private func createRequest(with url: URL?,
                                   type: HTTPMethod,
                                   completion: @escaping (URLRequest) -> Void) {
            guard let apiURL = url else {
                return
            }
            
            var request = URLRequest(url: apiURL)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    
    public func getTopStories(completion: @escaping(Result<TopHeadlinesModel, Error>) -> Void) {
        let url:URL? = Constants.topHeadlinesURL;
        fetchData(from: url, responseType: TopHeadlinesModel.self, requestType: .get, completion: completion)
    }
}
