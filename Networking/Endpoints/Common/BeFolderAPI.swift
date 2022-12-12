//
//  BeFolderAPI.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Netswift

/// This app's networking layer.
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


/// Funnel all `BeFolderEndpoint`s through this performer. Other `Endpoint` types could have other performers.
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
    
    /// The default configuration for the API routes & endpoints.
    static let main: BeFolderAPI = {
        let main = BeFolderAPI()
        Self.configure(using: main)
        return main
    }()
    
    /// A mock implementation & configuration for the API routes & endpoints.
    ///
    /// - returns: An API `Type` on which static routes & endpoints can be called.
    /// - note: The returned `Type` is not really any different from calling `BeFolderAPI.<Route>`, but the important part is configuring the shared instance with the given HTTP Performer, which this function call does.
    static func mock(_ httpPerformer: NetswiftHTTPPerformer) -> BeFolderAPI.Type {
        let mock = BeFolderAPI(performer: NetswiftPerformer(requestPerformer: httpPerformer))
        Self.configure(using: mock)
        return type(of: mock)
    }
}
