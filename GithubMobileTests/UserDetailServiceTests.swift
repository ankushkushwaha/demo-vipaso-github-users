//
//  UserDetailServiceTests.swift
//  GithubMobileTests
//
//  Created by Ankush Kushwaha on 21/06/24.
//

import Foundation
import XCTest
@testable import GithubMobile

final class UserDetailServiceTests: XCTestCase {

    func testFetchDataSuccess() async {
        let mockSession = MockTestURLSession()
        let sut = UserDetailService(session: mockSession)

        let result = await sut.fetchRepo(urlString: "https://api.github.com/users/ankushkushwaha/repos")

        switch result {
        case .success(let data):
            XCTAssertTrue(data.count > 0)

        case .failure(let err):
            XCTFail("Could not fetch data \(err)")
        }
    }

    func testFetchDataFail() async {
        var mockSession = MockTestURLSession()
        mockSession.error = MockTestURLSession.DataError.mockDataError

        let sut = UserDetailService(session: mockSession)

        let result = await sut.fetchRepo(urlString: "https://api.github.com/users/ankushkushwaha/repos")

        switch result {
        case .success:
            XCTFail("Fetch should not succeed.")

        case .failure(let err):
            XCTAssertEqual(MockTestURLSession.DataError.mockDataError,
                           err as! MockTestURLSession.DataError)
        }
    }

    func testInvalidUrl() async {
        var mockSession = MockTestURLSession()
        let sut = UserDetailService(session: mockSession)

        let result = await sut.fetchRepo(urlString: "")

        switch result {
        case .success:
            XCTFail("Fetch should not succeed.")

        case .failure(let err):
            let error = err as? NetworkingError
            XCTAssertEqual(error?.errorMessage,
                           NetworkingError.invalidURL.errorMessage )
        }
    }
}

extension UserDetailServiceTests {

    struct MockTestURLSession: UserDetailSessionProtocol {

        enum DataError: Error {
            case mockDataError
        }

        var error: Error?

        func fetchData(url: URL) async throws -> (Data, URLResponse) {

            if let error = error {
                throw error
            }

            return try await mockFetchData(url: url)
        }

        private func mockFetchData(url: URL) async throws -> (Data, URLResponse) {

            let fakeSuccessResponse = HTTPURLResponse(url: url,
                                                      statusCode: 200,
                                                      httpVersion: "HTTP/1.1",
                                                      headerFields: nil)

            let mockData = MockTestJsonData().getRepoJsonData()

            guard let mockData = mockData,
                  let response = fakeSuccessResponse else {
                throw DataError.mockDataError
            }
            return (mockData, response)
        }
    }
}
