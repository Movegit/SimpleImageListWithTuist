//
//  APIServiceTest.swift
//  SimpleImageListTests
//
//  Created by 배정환 on 4/8/25.
//

import Foundation
import XCTest
@testable import SimpleImageList

class APIServiceTests: XCTestCase {

    // MARK: - Test GET Request Success
    func testGetRequestSuccess() async throws {
        // Given
        let mockURL = "https://jsonplaceholder.typicode.com/posts"

        // When
        let result: [PostRequestSample] = try await APIHelperNoLibSample.get(url: mockURL)

        // Then
        XCTAssertFalse(result.isEmpty, "The result should not be empty.")
    }

    // MARK: - Test GET Request Failure (Invalid URL)
    func testGetRequestFailureInvalidURL() async {
        // Given
        let invalidURL = "invalid_url"

        do {
            // When
            let _: [PostRequestSample] = try await APIHelperNoLibSample.get(url: invalidURL)
            XCTFail("Expected to throw an invalid URL error.")
        } catch let error as APIError {
            // Then
            XCTAssertEqual(error, .invalidURL, "Expected invalid URL error.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Test POST Request Success
    func testPostRequestSuccess() async throws {
        // Given
        let mockURL = "https://jsonplaceholder.typicode.com/posts"
        let requestBody: [String: Any] = [
            "title": "foo",
            "body": "bar",
            "userId": 1
        ]

        // When
        let result: PostRequestSample = try await APIHelperNoLibSample.post(url: mockURL, body: requestBody)

        // Then
        XCTAssertEqual(result.title, "foo", "The title should match the request body.")
        XCTAssertEqual(result.body, "bar", "The body should match the request body.")
    }

    // MARK: - Test PUT Request Success
    func testPutRequestSuccess() async throws {
        // Given
        let mockURL = "https://jsonplaceholder.typicode.com/posts/1"
        let requestBody: [String: Any] = [
            "id": 1,
            "title": "updated title",
            "body": "updated body",
            "userId": 1
        ]

        // When
        let result: PostRequestSample = try await APIHelperNoLibSample.put(url: mockURL, body: requestBody)

        // Then
        XCTAssertEqual(result.title, "updated title", "The title should match the updated value.")
    }

    // MARK: - Test DELETE Request Success
    func testDeleteRequestSuccess() async throws {
        // Given
        let mockURL = "https://jsonplaceholder.typicode.com/posts/1"

        // When
        let result: EmptyResponse = try await APIHelperNoLibSample.delete(url: mockURL)

        // Then
        XCTAssertNotNil(result, "The delete response should not be nil.")
    }
}

// MARK: - Mock Models for Testing

struct PostRequestSample: Decodable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
}

struct EmptyResponse: Decodable {}

