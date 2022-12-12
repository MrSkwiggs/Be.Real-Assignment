//
//  BeFolderEndpoint.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Netswift

/// A type that represents how a BeFolder request is routed, serialised, decoded & performed.
public protocol BeFolderEndpoint: NetswiftRoute, NetswiftRequest, NetswiftRequestPerformable {}

/// A type that represents a BeFolder request that requires authentication
public protocol BeFolderAuthenticatedEndpoint: BeFolderEndpoint {
    
    /// This request's auth token.
    var token: String { get }
}

// MARK: - Default Implementations

public extension BeFolderEndpoint {
    var scheme: String { GenericScheme.http.rawValue }
    var host: String? { "163.172.147.216" }
    var port: String { "8080" }
    
    var url: URL {
        let scheme = self.scheme
        let host = (self.host ?? "").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let path = (self.path ?? "").addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let query = (self.query ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var fragment = ""
        if let unwrappedFragment = self.fragment { fragment = "#\(unwrappedFragment)" }
        fragment = fragment.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        return URL(string: "\(scheme)\(host):\(port)\(path)\(query)\(fragment)")!
    }
}

public extension BeFolderEndpoint where Response: Decodable {
    func deserialise(_ incomingData: Data) -> NetswiftResult<Response> {
        Self.defaultDeserialise(incomingData: incomingData)
    }
    
    /// Default deserialisation logic.
    ///
    /// Can be used to decode any decodable type, but defaults to decoding the `Response` type.
    static func defaultDeserialise<T: Decodable>(type: T.Type = Response.self, incomingData: Data) -> NetswiftResult<T> {
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

// MARK: - Default authentication request serialisation

public extension BeFolderAuthenticatedEndpoint {
    func serialise() -> NetswiftResult<URLRequest> {
        var request = URLRequest(url: self.url)
        
        request.setHTTPMethod(self.method)
        
        var headers = self.additionalHeaders
        
        headers.append(.contentType(contentType))
        headers.append(.accept(accept))
        headers.append(.basicAuthentication(token: token))
        
        request.setHeaders(headers)
        
        do {
            if let encoder = bodyEncoder {
                request.httpBody = try body(encodedBy: encoder)
            }
        } catch {
            return .failure(.init(.requestSerialisationError))
        }
        
        return .success(request)
    }
}
