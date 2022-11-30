//
//  BeFolderEndpoint.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Netswift

public class BeFolderEndpoint<Response: Decodable>: BeFolderAPI, NetswiftRequest, NetswiftRoute {
    
    let token: String
    
    init(token: String) {
        self.token = token
        super.init()
    }
    
    public var scheme: String { GenericScheme.http.rawValue }
    public var host: String? { BeFolderAPI.domain }
    public var port: String { "8080" }
    public var path: String? { nil }
    public var query: String? { nil }
    
    public var url: URL {
        let scheme = self.scheme
        let host = (self.host ?? "").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let path = (self.path ?? "").addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let query = (self.query ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var fragment = ""
        if let unwrappedFragment = self.fragment { fragment = "#\(unwrappedFragment)" }
        fragment = fragment.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        return URL(string: "\(scheme)\(host):\(port)\(path)\(query)\(fragment)")!
    }
    
    public func serialise() -> NetswiftResult<URLRequest> {
        var request = URLRequest(url: self.url)
        
        request.setHTTPMethod(self.method)
        
        var headers = self.additionalHeaders
        
        headers.append(.contentType(contentType))
        headers.append(.accept(accept))
        headers.append(.basicAuthentication(token: token))
        
        request.setHeaders(headers)
        
        return .success(request)
    }
    
    public func deserialise(_ incomingData: Data) -> NetswiftResult<Response> {
        Self.defaultDeserialise(incomingData: incomingData)
    }
    
    public static func defaultDeserialise<T: Decodable>(type: T.Type = Response.self, incomingData: Data) -> NetswiftResult<T> {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedResponse = try decoder.decode(T.self, from: incomingData)
            return .success(decodedResponse)
            
        } catch let error as DecodingError {
            return .failure(.init(category: .responseDecodingError(error: error), payload: incomingData))
        } catch {
            return .failure(.init(category: .unexpectedResponseError, payload: incomingData))
        }
    }
}

extension BeFolderEndpoint: NetswiftRequestPerformable {
    @discardableResult public func perform(_ handler: @escaping NetswiftHandler<Response>) -> NetswiftTask? {
        return perform(self, handler)
    }
    
    @discardableResult public func perform(deadline: DispatchTime, _ handler: @escaping NetswiftHandler<Response>) -> NetswiftTask? {
        return perform(self, deadline: deadline, handler)
    }
    
    public func perform() async -> NetswiftResult<Response> {
        return await perform(self)
    }
}
