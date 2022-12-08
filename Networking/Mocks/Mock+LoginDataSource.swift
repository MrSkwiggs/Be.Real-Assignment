//
//  Mock+LoginDataSource.swift
//  Networking
//
//  Created by Dorian on 08/12/2022.
//

import Netswift

extension Mock {
    public class LoginDataSource: LoginDataSourceContract {
        
        let result: NetswiftResult<User>
        
        /// The latest value sent to the `login(_:)` func.
        public var token: String?
        
        init(result: NetswiftResult<User>) {
            self.result = result
        }
        
        public func login(token: String, callback: NetswiftHandler<User>) -> NetswiftTask? {
            self.token = token
            callback(result)
            return nil
        }
    }
}
