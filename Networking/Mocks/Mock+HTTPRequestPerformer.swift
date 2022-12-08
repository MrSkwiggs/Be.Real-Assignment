//
//  Mock+HTTPRequestPerformer.swift
//  Networking
//
//  Created by Dorian on 08/12/2022.
//

import Netswift

extension Mock {
    
    /**
     A mock HTTP Performer that can be set to return specific responses
     */
    class HTTPRequestPerformer: NetswiftHTTPPerformer {
        
        let result: NetswiftResult<Data?>
        
        init(result: NetswiftResult<Data?>) {
            self.result = result
        }
        
        init<T: Encodable>(result: T) {
            self.result = .success(try! JSONEncoder().encode(result))
        }
        
        override func perform(_ request: URLRequest) async -> NetswiftResult<Data?> {
            return result
        }
        
        override func perform(_ request: URLRequest, completion: @escaping (NetswiftResult<Data?>) -> Void) -> NetswiftTask {
            completion(result)
            return URLSessionDataTask()
        }
        
        override func perform(_ request: URLRequest, waitUpTo deadline: DispatchTime = .now() + .seconds(5), completion: @escaping (NetswiftResult<Data?>) -> Void) -> NetswiftTask {
            completion(result)
            return URLSessionDataTask()
        }
    }
}
