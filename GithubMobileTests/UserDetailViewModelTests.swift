//
//  UserDetailViewModelTests.swift
//  GithubMobileTests
//
//  Created by Ankush Kushwaha on 21/06/24.
//

import XCTest
@testable import GithubMobile

final class UserDetailViewModelTests: XCTestCase {

    func testFetchReposSuccess() async {
        let mockService = MockService()

        let sut = UserDetailViewModel(user: mockUser, service: mockService)

        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.repos.count, 0)

        await sut.fetchRepo()

        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.repos.count, 30)
    }

    func testFetchUsersFail() async {

        var mockService = MockService()
        mockService.error = NetworkingError.requestFailed("Mock fetch failed")

        let sut = UserDetailViewModel(user: mockUser, service: mockService)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.repos.count, 0)

        await sut.fetchRepo()

        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.error?.errorId,
                       NetworkingError.requestFailed("Mock fetch failed").errorId)
        XCTAssertEqual(sut.repos.count, 0)
    }
}

extension UserDetailViewModelTests {

    struct MockService: UserDetailServiceProtocol {

        enum DataError: Error {
            case requestFailed
        }
        var urlSession: URLSessionProtocol = MockURLSessionPlaceholder()

        var error: Error?

        func fetchRepo(urlString: String) async -> Result<[Repo], Error> {
            if let error = error {
                return .failure(error)

            } else if let models = MockTestModelProvider().repoList() {
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

    private var mockUser: User {
        let user = User(id: 11902070,
                        login: "ankushkushwaha",
                        avatarUrl: "https://avatars.githubusercontent.com/u/11902070?v=4",
                        repoUrl: "https://api.github.com/users/ankushkushwaha/repos")
        return user
    }
}
