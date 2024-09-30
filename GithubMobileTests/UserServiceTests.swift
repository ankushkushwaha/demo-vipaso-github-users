//
//  UserServiceTests.swift
//  GithubMobileTests
//
//  Created by Ankush Kushwaha on 21/06/24.
//

import XCTest
@testable import GithubMobile

final class UserServiceTests: XCTestCase {

    func testFetchUserListSuccess() async throws {
        let mockSession = MockTestURLSession()
        let sut = UserService(session: mockSession)

        let result = await sut.fetchUserList(searchQuery: "abc", page: 1, usersPerPage: 10)

        switch result {
        case .success(let data):

            XCTAssertTrue(data.items.count > 0)
            XCTAssertEqual(data.items.first?.id, 9079960) // First item's id in mock data

        case .failure(let err):
            XCTFail("Could not fetch data \(err)")
        }
    }

    func testFetchUserListFailure() async throws {
        var mockSession = MockTestURLSession()
        mockSession.error = MockTestURLSession.DataError.mockDataError

        let sut = UserService(session: mockSession)

        let result = await sut.fetchUserList(searchQuery: "abc", page: 1, usersPerPage: 10)

        switch result {
        case .success:
            XCTFail("Fetch should not succeed.")

        case .failure(let err):
            XCTAssertEqual(MockTestURLSession.DataError.mockDataError,
                           err as! MockTestURLSession.DataError)
        }
    }

}

struct MockTestURLSession: URLSessionProtocol {

    enum DataError: Error {
        case mockDataError
    }

    var error: Error?

    func fetchData<T>(type: T.Type, request: URLRequest) async throws -> (Data, URLResponse) {

        if let error = error {
            throw error
        }

        return try await mockFetchData(request: request)
    }

    private func mockFetchData(request: URLRequest) async throws -> (Data, URLResponse) {

        guard let url = request.url else {
            throw DataError.mockDataError
        }
        
        let fakeSuccessResponse = HTTPURLResponse(url: url,
                                                  statusCode: 200,
                                                  httpVersion: "HTTP/1.1",
                                                  headerFields: nil)

        let mockData = MockJsonData().getJsonData()

        guard let mockData = mockData,
              let response = fakeSuccessResponse else {
            throw DataError.mockDataError
        }
        return (mockData, response)
    }
}
