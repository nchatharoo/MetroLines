//
//  APIError.swift
//  WhereToWatch
//
//  Created by Chatharoo on 22/06/2020.
//  Copyright © 2020 Chatharoo. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case unknown
    case message(reason: String), parseError(reason: String), networkError(reason: String)

    static func processResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }
        if (httpResponse.statusCode == 401) {
            throw APIError.message(reason: "Authorization failed");
        }
        if (httpResponse.statusCode == 404) {
            throw APIError.message(reason: "Resource not found");
        }
        return data
    }

}
