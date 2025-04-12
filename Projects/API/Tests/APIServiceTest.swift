//
//  APIServiceTest.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import XCTest
import Quick
import Nimble
@testable import JHAPIService

class APIServiceTests: QuickSpec {

    override func spec() {
        describe("APIHelperNoLibSample") {

            // MARK: - Test GET Request Success
            context("when performing a GET request") {
                it("should return a non-empty result on success") {
                    let mockURL = "https://jsonplaceholder.typicode.com/posts"

                    Task {
                        do {
                            let result: [PostRequestSample] = try await APIHelperNoLibSample.shared.get(url: mockURL)
                            expect(result).toNot(beEmpty(), description: "The result should not be empty.")
                        } catch {
                            fail("Unexpected error: \(error)")
                        }
                    }
                }

                it("should throw an invalid URL error for an invalid URL") {
                    let invalidURL = "invalid_url"

                    Task {
                        do {
                            let _: [PostRequestSample] = try await APIHelperNoLibSample.shared.get(url: invalidURL)
                            fail("Expected to throw an invalid URL error.")
                        } catch let error as APIError {
                            expect(error).to(equal(.invalidURL), description: "Expected invalid URL error.")
                        } catch {
                            fail("Unexpected error: \(error)")
                        }
                    }
                }
            }

            // MARK: - Test POST Request Success
            context("when performing a POST request") {
                it("should return the correct result on success") {
                    let mockURL = "https://jsonplaceholder.typicode.com/posts"
                    let requestBody: [String: Any] = [
                        "title": "foo",
                        "body": "bar",
                        "userId": 1
                    ]

                    Task {
                        do {
                            let result: PostRequestSample = try await APIHelperNoLibSample.shared.post(url: mockURL, body: requestBody)
                            expect(result.title).to(equal("foo"), description: "The title should match the request body.")
                            expect(result.body).to(equal("bar"), description: "The body should match the request body.")

                        } catch {
                            fail("Unexpected error: \(error)")

                        }
                    }
                }
            }

            // MARK: - Test PUT Request Success
            context("when performing a PUT request") {
                it("should update and return the correct result on success") {
                    let mockURL = "https://jsonplaceholder.typicode.com/posts/1"
                    let requestBody: [String: Any] = [
                        "id": 1,
                        "title": "updated title",
                        "body": "updated body",
                        "userId": 1
                    ]

                    Task {
                        do {
                            let result: PostRequestSample = try await APIHelperNoLibSample.shared.put(url: mockURL, body: requestBody)
                            expect(result.title).to(equal("updated title"), description: "The title should match the updated value.")
                        } catch {
                            fail("Unexpected error: \(error)")
                        }
                    }
                }
            }

            // MARK: - Test DELETE Request Success
            context("when performing a DELETE request") {
                it("should return a non-nil response on success") {
                    let mockURL = "https://jsonplaceholder.typicode.com/posts/1"

                    Task {
                        do {
                            let result: EmptyResponse = try await APIHelperNoLibSample.shared.delete(url: mockURL)
                            expect(result).toNot(beNil(), description: "The delete response should not be nil.")
                        } catch {
                            fail("Unexpected error: \(error)")
                        }
                    }
                }
            }
        }
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
