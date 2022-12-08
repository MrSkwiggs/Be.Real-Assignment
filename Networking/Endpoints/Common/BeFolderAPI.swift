//
//  BeFolderAPI.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Netswift

public struct BeFolderAPI {
    
    fileprivate static var shared: BeFolderAPI = .init()
    
    fileprivate static func configure(using sharedInstance: BeFolderAPI) {
        shared = sharedInstance
    }
    
    private let performer: NetswiftNetworkPerformer
    
    private init(performer: NetswiftNetworkPerformer = NetswiftPerformer()) {
        self.performer = performer
    }
    
    fileprivate func perform<Endpoint: BeFolderEndpoint>(_ endpoint: Endpoint,
                                                       deadline: DispatchTime? = nil,
                                                       _ handler: @escaping NetswiftHandler<Endpoint.Response>) -> NetswiftTask? {
        return performer.perform(endpoint, deadline: deadline) { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }
    }
    
    fileprivate func perform<Endpoint: BeFolderEndpoint>(_ endpoint: Endpoint) async -> NetswiftResult<Endpoint.Response> {
        return await performer.perform(endpoint)
    }
}

public extension NetswiftRequestPerformable where Self: BeFolderEndpoint {
    @discardableResult func perform(_ handler: @escaping NetswiftHandler<Self.Response>) -> NetswiftTask? {
        return BeFolderAPI.shared.perform(self, handler)
    }
    
    @discardableResult func perform(deadline: DispatchTime, _ handler: @escaping NetswiftHandler<Self.Response>) -> NetswiftTask? {
        return BeFolderAPI.shared.perform(self, deadline: deadline, handler)
    }
    
    func perform() async -> NetswiftResult<Self.Response> {
        return await BeFolderAPI.shared.perform(self)
    }
}

public extension BeFolderAPI {
    static let main: BeFolderAPI = {
        let main = BeFolderAPI()
        Self.configure(using: main)
        return main
    }()
    
    static func mock(_ httpPerformer: NetswiftHTTPPerformer) -> BeFolderAPI {
        let mock = BeFolderAPI(performer: NetswiftPerformer(requestPerformer: httpPerformer))
        Self.configure(using: mock)
        return mock
    }
}
