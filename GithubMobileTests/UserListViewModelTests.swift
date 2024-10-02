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
        XCTAssertEqual(sut.users.count, 0)

        await sut.fetchUsers(searchText: "abc", page: 1)

        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.users.count, 30)

    }

    func testFetchUsersFail() async {

        var mockService = MockService()
        mockService.error = NetworkingError.requestFailed("Mock fetch failed")

        let sut = UserListViewModel(service: mockService)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.users.count, 0)

        await sut.fetchUsers(searchText: "abc", page: 1)

        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.error?.errorId,
                       NetworkingError.requestFailed("Mock fetch failed").errorId)
        XCTAssertEqual(sut.users.count, 0)
    }
}

extension UserListViewModelTests {

    struct MockService: UserSearchServiceProtocol {

        enum DataError: Error {
            case requestFailed
        }
        var urlSession: URLSessionProtocol = MockURLSessionPlaceholder()

        var error: Error?

        func fetchUserList(searchQuery: String, page: Int, usersPerPage: Int) async -> Result<UserResponse, any Error> {
            if let error = error {
                return .failure(error)

            } else if let model = MockModelProvider().userListResponse() {
                return .success(model)
            }

            return .failure(NetworkingError.requestFailed("Mock fetch request failed"))
        }
    }

    struct MockURLSessionPlaceholder: URLSessionProtocol {
        func fetchData<T>(type: T.Type, request: URLRequest) async throws -> (Data, URLResponse) {
            fatalError("MockURLSessionPlaceHolder method called")

        }
    }
}
