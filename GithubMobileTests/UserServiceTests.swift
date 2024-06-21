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
        
        let result = await sut.fetchUserList(searchQuery: "abc")
        
        switch result {
        case .success(let data):
            
            XCTAssertTrue(data.count > 0)
            XCTAssertEqual(data.first?.id, 9079960)
            
        case .failure(let err):
            XCTFail("Could not fetch data \(err)")
        }
    }
    
    func testFetchUserListFailure() async throws {
        var mockSession = MockTestURLSession()
        mockSession.error = MockTestURLSession.DataError.mockDataError
        
        let sut = UserService(session: mockSession)

        let result = await sut.fetchUserList(searchQuery: "abc")
        
        switch result {
        case .success(_):
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
        
        let mockData = MockTestJsonData().getJsonData()
        
        guard let mockData = mockData,
              let response = fakeSuccessResponse else {
            throw DataError.mockDataError
        }
        return (mockData, response)
    }
}

