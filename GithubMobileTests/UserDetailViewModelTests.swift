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
        XCTAssertEqual(sut.repos.count, 27)
    }

    func testFetchReposFail() async {

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

    func testFetchUserDetailSuccess() async {
        let mockService = MockService()

        let sut = UserDetailViewModel(user: mockUser, service: mockService)

        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.followers, "-")

        await sut.fetchUserDetail()

        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.followers, "3") // In Mock followers = 3
    }

    func testFetchUserDetailFail() async {
        var mockService = MockService()
        mockService.error = NetworkingError.requestFailed("Mock fetch failed")

        let sut = UserDetailViewModel(user: mockUser, service: mockService)

        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.followers, "-")

        await sut.fetchUserDetail()

        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.error?.errorId,
                       NetworkingError.requestFailed("Mock fetch failed").errorId)
        XCTAssertEqual(sut.followers, "-")
    }

    func testBlog() async {
        let mockService = MockService()
        let sut = UserDetailViewModel(user: mockUser, service: mockService)
        await sut.fetchUserDetail()

        XCTAssertEqual(sut.blog, "https://api.github.com/users/ankushkushwaha")
    }
    
    func testFetchNextPage() async {
        let mockService = MockService()

        let sut = UserDetailViewModel(user: mockUser, service: mockService)

        XCTAssertEqual(sut.currentRepoPage, 1)

        // fetchUserDetail sets totalRepoPages, based on which we increase our currentRepoPage
        
        await sut.fetchUserDetail()
        
        sut.fetchNextRepoPage()
        
        XCTAssertEqual(sut.currentRepoPage, 1)
    }
    
    func testFilteredRepo() async {
        let mockService = MockService()

        let sut = UserDetailViewModel(user: mockUser, service: mockService)

        await sut.fetchRepo(page: 1)
        
        XCTAssertEqual(sut.filteredRepo.count, 14)
        
        sut.showForkedRepos = true
        XCTAssertEqual(sut.filteredRepo.count, 27)
    }
    
    // Computed property tests
    
    func testHireable() async {
        let mockService = MockService()
        
        let sut = UserDetailViewModel(user: mockUser, service: mockService)
        
        await sut.fetchUserDetail()
        
        XCTAssertEqual(sut.hireable, "Yes")
    }
    
    func testImageUrl() async {
        let mockService = MockService()
        let sut = UserDetailViewModel(user: mockUser, service: mockService)
        await sut.fetchUserDetail()
        XCTAssertEqual(sut.imageUrl, "https://avatars.githubusercontent.com/u/11902070?v=4")
    }
    
    func testFollowers() async {
        let mockService = MockService()
        let sut = UserDetailViewModel(user: mockUser, service: mockService)
        await sut.fetchUserDetail()

        XCTAssertEqual(sut.followers, "3")
    }

    func testFollowing() async {
        let mockService = MockService()
        let sut = UserDetailViewModel(user: mockUser, service: mockService)
        await sut.fetchUserDetail()

        XCTAssertEqual(sut.followings, "14")
    }

    func testPublicGists() async {
        let mockService = MockService()
        let sut = UserDetailViewModel(user: mockUser, service: mockService)
        await sut.fetchUserDetail()

        XCTAssertEqual(sut.publicGists, "1")
    }

    func testPublicRepo() async {
        let mockService = MockService()
        let sut = UserDetailViewModel(user: mockUser, service: mockService)
        await sut.fetchUserDetail()

        XCTAssertEqual(sut.publicRepos, "27")
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

            } else if let models = MockModelProvider().repoList() {
                return .success(models)
            }

            return .failure(NetworkingError.requestFailed("Mock fetch request failed"))
        }

        func fetchUserDetail(userName: String) async -> Result<GithubMobile.User, any Error> {
            if let error = error {
                return .failure(error)

            } else if let models = MockModelProvider().userDetail() {
                return .success(models)
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

extension UserDetailViewModelTests {
    private var mockUser: User {
        let user =  User(id: 11902070, login: "ankushkushwaha",
                        blog: nil,
                         followers: nil, following: nil,
                         name: "Ankush",
                         hireable: false,
                         avatarUrl: "https://avatars.githubusercontent.com/u/11902070?v=4",
                         repoUrl: "https://api.github.com/users/ankushkushwaha/repos",
                         publicGists: nil,
                         publicRepos: nil)
        return user
    }
}
