//
//  APIService.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation

public protocol APIHelperProtocol {
    func get<T: Decodable>(
        url: String,
        queryParameters: [String: Any]?,
        headers: [String: Any]?,
        completion: @escaping (Result<T, APIError>) -> Void)
    func post<T: Decodable>(
        url: String,
        body: [String: Any],
        headers: [String: String]?,
        completion: @escaping (Result<T, APIError>) -> Void)
    func put<T: Decodable>(
        url: String,
        body: [String: Any],
        headers: [String: String]?,
        completion: @escaping (Result<T, APIError>) -> Void)
    func delete<T: Decodable>(
        url: String,
        queryParameters: [String: Any]?,
        headers: [String: Any]?,
        completion: @escaping (Result<T, APIError>) -> Void)
    func get<T: Decodable>(
        url: String,
        queryParameters: [String: Any]?,
        headers: [String: Any]?
    ) async throws -> T

    func post<T: Decodable>(url: String,
                            body: [String: Any],
                            headers: [String: String]?
    ) async throws -> T

    func put<T: Decodable>(
        url: String,
        body: [String: Any],
        headers: [String: String]?
    ) async throws -> T

    func delete<T: Decodable>(
        url: String,
        queryParameters: [String: Any]?,
        headers: [String: Any]?
    ) async throws -> T
}

public enum APIError: Error, Equatable {
    case invalidURL
    case noData
    case decodingFailed
    case networkError(Error)
    case invalidStatusCode(Int)

    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
            (.noData, .noData),
            (.decodingFailed, .decodingFailed):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return (lhsError as NSError).domain == (rhsError as NSError).domain &&
            (lhsError as NSError).code == (rhsError as NSError).code
        case (.invalidStatusCode(let lhsCode), .invalidStatusCode(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}

public class APIHelperNoLibSample: APIHelperProtocol {
    public static let shared = APIHelperNoLibSample()

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    private func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        queryParameters: [String: Any]? = nil,
        body: [String: Any]? = nil,
        headers: [String: Any]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let urlComponents = URLComponents(string: url),
                      let finalURL = urlComponents.url,
                      let scheme = urlComponents.scheme,
                      !scheme.isEmpty,
                      let host = urlComponents.host,
                      !host.isEmpty else {
            completion(.failure(.invalidURL))
            return
        }
        // Add query parameters for GET requests
        var components = urlComponents

        // GET 요청에 대한 쿼리 파라미터 추가
        if method == .get, let queryParameters = queryParameters {
            components.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }

        guard let queryUrl = components.url else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: queryUrl)
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
    open func get<T: Decodable>(
        url: String,
        queryParameters: [String: Any]? = nil,
        headers: [String: Any]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request(url: url, method: .get, queryParameters: queryParameters, headers: headers, completion: completion)
    }

    open func post<T: Decodable>(
        url: String,
        body: [String: Any],
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request(url: url, method: .post, body: body, headers: headers, completion: completion)
    }

    open func put<T: Decodable>(
        url: String,
        body: [String: Any],
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request(url: url, method: .put, body: body, headers: headers, completion: completion)
    }

    open func delete<T: Decodable>(
        url: String,
        queryParameters: [String: Any]? = nil,
        headers: [String: Any]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request(url: url, method: .delete, queryParameters: queryParameters, headers: headers, completion: completion)
    }

    private func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        queryParameters: [String: Any]? = nil,
        body: [String: Any]? = nil,
        headers: [String: Any]? = nil
    ) async throws -> T {
        guard let urlComponents = URLComponents(string: url),
                      let finalURL = urlComponents.url,
                      let scheme = urlComponents.scheme,
                      !scheme.isEmpty,
                      let host = urlComponents.host,
                      !host.isEmpty else {
            throw APIError.invalidURL
        }
        // Add query parameters for GET requests
        var components = urlComponents

        // GET 요청에 대한 쿼리 파라미터 추가
        if method == .get, let queryParameters = queryParameters {
            components.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }

        guard let queryUrl = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: queryUrl)
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
    open func get<T: Decodable>(
        url: String,
        queryParameters: [String: Any]? = nil,
        headers: [String: Any]? = nil
    ) async throws -> T {
        try await request(url: url, method: .get, queryParameters: queryParameters, headers: headers)
    }

    open func post<T: Decodable>(url: String,
                                   body: [String: Any],
                                   headers: [String: String]? = nil
    ) async throws -> T {
        try await request(url: url, method: .post, body: body, headers: headers)
    }

    open func put<T: Decodable>(
        url: String,
        body: [String: Any],
        headers: [String: String]? = nil
    ) async throws -> T {
        try await request(url: url, method: .put, body: body, headers: headers)
    }

    open func delete<T: Decodable>(
        url: String,
        queryParameters: [String: Any]? = nil,
        headers: [String: Any]? = nil
    ) async throws -> T {
        try await request(url: url, method: .delete, queryParameters: queryParameters, headers: headers)
    }
}
