//
//  MockTestJsonData.swift
//  GithubMobileTests
//
//  Created by Ankush Kushwaha on 20/06/24.
//

import Foundation

class MockJsonData {

    func getJsonData() -> Data? {
        getMockData(fileName: "MockTestData")
    }

    func getRepoJsonData() -> Data? {
        getMockData(fileName: "MockRepoData")
    }

    func getUserDetailJsonData() -> Data? {
        getMockData(fileName: "MockUserDetail")
    }

    private func getMockData(fileName: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let fileURL = bundle.url(forResource: fileName, withExtension: "json") else {
            print("\(fileName) json file not found.")
            return nil
        }
        do {
            let jsonData = try Data(contentsOf: fileURL)
            return jsonData
        } catch {
            print("Error while fething data from mock json file: \(error)")
            return nil
        }
    }
}
