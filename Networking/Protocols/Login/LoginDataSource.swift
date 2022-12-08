//
//  LoginDataSource.swift
//  Networking
//
//  Created by Dorian on 08/12/2022.
//

import Netswift

public protocol LoginNetworkDataSource {
    func login(token: String, callback: @escaping NetswiftHandler<User>) -> NetswiftTask?
}
