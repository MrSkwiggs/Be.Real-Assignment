//
//  Mock+LoginDataSource.swift
//  Networking
//
//  Created by Dorian on 08/12/2022.
//

import Netswift

extension Mock {
    public struct LoginProvider: LoginNetworkDataSource {
        
        let result: NetswiftResult<User>
        
        public func login(token: String, callback: NetswiftHandler<User>) -> Netswift.NetswiftTask? {
            callback(result)
            return nil
        }
    }
}
