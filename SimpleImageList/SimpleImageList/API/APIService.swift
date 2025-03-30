//
//  APIService.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case networkError(Error)
    case invalidStatusCode(Int)
}

class APIHelperNoLibSample {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    static func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        queryParameters: [String: Any]? = nil,
        body: [String: Any]? = nil,
        headers: [String: Any]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        var urlComponents = URLComponents(string: url)
        
        // GET 요청에 대한 쿼리 파라미터 추가
        if method == .get, let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 헤더 추가
        headers?.forEach { key, value in
            if let stringValue = value as? String {
                request.addValue(stringValue, forHTTPHeaderField: key)
            } else {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        // POST, PUT 요청에 대한 본문 추가
        if let body = body, method == .post || method == .put {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(.networkError(error)))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.networkError(NSError(domain: "APIHelper",
                                                          code: 0,
                                                          userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidStatusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        
        task.resume()
    }
    
    // 편의 메서드들
    static func get<T: Decodable>(
        url: String,
        queryParameters: [String: Any]? = nil,
        headers: [String: Any]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request(url: url, method: .get, queryParameters: queryParameters, headers: headers, completion: completion)
    }
    
    static func post<T: Decodable>(
        url: String,
        body: [String: Any],
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request(url: url, method: .post, body: body, headers: headers, completion: completion)
    }
    
    static func put<T: Decodable>(
        url: String,
        body: [String: Any],
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request(url: url, method: .put, body: body, headers: headers, completion: completion)
    }
    
    static func delete<T: Decodable>(
        url: String,
        queryParameters: [String: Any]? = nil,
        headers: [String: Any]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request(url: url, method: .delete, queryParameters: queryParameters, headers: headers, completion: completion)
    }
    
    static func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        queryParameters: [String: Any]? = nil,
        body: [String: Any]? = nil,
        headers: [String: Any]? = nil
    ) async throws -> T {
        var urlComponents = URLComponents(string: url)
        
        // GET 요청에 대한 쿼리 파라미터 추가
        if method == .get, let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 헤더 추가
        headers?.forEach { key, value in
            if let stringValue = value as? String {
                request.addValue(stringValue, forHTTPHeaderField: key)
            } else {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        // POST, PUT 요청에 대한 본문 추가
        if let body = body, method == .post || method == .put {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: "APIHelper", code: 0,
                                                userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode(httpResponse.statusCode)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw APIError.decodingFailed
        }
    }

    // 편의 메서드들
    static func get<T: Decodable>(
        url: String,
        queryParameters: [String: Any]? = nil,
        headers: [String: Any]? = nil
    ) async throws -> T {
        try await request(url: url, method: .get, queryParameters: queryParameters, headers: headers)
    }

    static func post<T: Decodable>(url: String,
                                   body: [String: Any],
                                   headers: [String: String]? = nil
    ) async throws -> T {
        try await request(url: url, method: .post, body: body, headers: headers)
    }

    static func put<T: Decodable>(
        url: String,
        body: [String: Any],
        headers: [String: String]? = nil
    ) async throws -> T {
        try await request(url: url, method: .put, body: body, headers: headers)
    }

    static func delete<T: Decodable>(
        url: String,
        queryParameters: [String: Any]? = nil,
        headers: [String: Any]? = nil
    ) async throws -> T {
        try await request(url: url, method: .delete, queryParameters: queryParameters, headers: headers)
    }
    
}
