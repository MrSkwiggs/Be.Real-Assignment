//
//  BeFolderAPI+LoginDataSource.swift
//  Networking
//
//  Created by Dorian on 08/12/2022.
//

import Netswift

extension BeFolderAPI: LoginNetworkDataSource {
    public func login(token: String, callback: @escaping NetswiftHandler<User.Response>) -> NetswiftTask? {
        User(token: token).perform(callback)
    }
}
