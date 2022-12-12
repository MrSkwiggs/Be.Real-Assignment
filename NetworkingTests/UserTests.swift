//
//  UserTests.swift
//  NetworkingTests
//
//  Created by Dorian on 10/12/2022.
//

import XCTest
@testable import Networking

final class UserTests: XCTestCase {

    func testResponseParsing() async {
        let userJSON = """
        {
            "firstName": "Noel",
            "lastName": "Flantier",
            "rootItem": {
                "id": "4b8e41fd4a6a89712f15bbf102421b9338cfab11",
                "parentId": "",
                "name": "dossierTest",
                "isDir": true,
                "modificationDate": "2021-11-29T10:57:13Z"
            }
        }
        """
        
        let expectedUser = User(firstName: "Noel",
                                lastName: "Flantier",
                                rootFolder: .init(id: "4b8e41fd4a6a89712f15bbf102421b9338cfab11",
                                                  parentID: nil,
                                                  name: "dossierTest",
                                                  modificationDate: date(from: "2021-11-29T10:57:13Z")))
        
        let performer = Mock.HTTPRequestPerformer(result: .success(userJSON.data(using: .utf8)))
        let api = BeFolderAPI.mock(performer)
        
        let result = await api.User(token: "whatever").perform()
        
        switch result {
        case let .success(user):
            XCTAssertEqual(user, expectedUser, "Unexpected User deviation")
            
        case .failure:
            XCTFail("Unexpected failure")
        }
    }
}

private func date(from string: String) -> Date {
    let formatter = ISO8601DateFormatter()
    return formatter.date(from: string)!
}
