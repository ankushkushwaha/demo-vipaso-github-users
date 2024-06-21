//
//  UserListViewModelTests.swift
//  GithubMobileTests
//
//  Created by Ankush Kushwaha on 21/06/24.
//

import XCTest
@testable import GithubMobile

final class UserListViewModelTests: XCTestCase {

    func testFetchUsersSuccess() async {
        let mockService = MockService()

        let sut = UserListViewModel(service: mockService)

        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.data.count, 0)

        await sut.fetchUsers(searchText: "abc")

        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.data.count, 30)

    }

    func testFetchUsersFail() async {

        var mockService = MockService()
        mockService.error = NetworkingError.requestFailed("Mock fetch failed")

        let sut = UserListViewModel(service: mockService)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.data.count, 0)

        await sut.fetchUsers(searchText: "abc")

        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.error?.errorId,
                       NetworkingError.requestFailed("Mock fetch failed").errorId)
        XCTAssertEqual(sut.data.count, 0)
    }
}

extension UserListViewModelTests {

    struct MockService: UserServiceProtocol {

        enum DataError: Error {
            case requestFailed
        }
        var urlSession: URLSessionProtocol = MockURLSessionPlaceholder()

        var error: Error?

        func fetchUserList(searchQuery: String) async -> Result<[User], Error> {
            if let error = error {
                return .failure(error)

            } else if let models = MockTestModelProvider().userList() {
                return .success(models)
            }

            return .failure(NetworkingError.requestFailed("Mock fetch request failed"))
        }
    }

    struct MockURLSessionPlaceholder: URLSessionProtocol {
        func fetchData(url: URL) async throws -> (Data, URLResponse) {
            fatalError("MockURLSessionPlaceHolder method called")
        }
    }
}
