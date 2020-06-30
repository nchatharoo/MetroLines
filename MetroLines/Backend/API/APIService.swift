//
//  APIService.swift
//  WhereToWatch
//
//  Created by Chatharoo on 15/06/2020.
//  Copyright © 2020 Chatharoo. All rights reserved.
//

import SwiftUI
import Combine

public struct APIService {
    
    public static let BASE_URL = URL(string: "https://restratpws.azurewebsites.net/api/Missions/100110013/from/132/way/R")!
    
    public static func fetch() -> AnyPublisher<[String], APIError> {
        URLSession.shared.dataTaskPublisher(for: APIService.BASE_URL)
            .tryMap({ result in
                guard let urlResponse = result.response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
                    throw APIError.unknown
                }
                return try! JSONDecoder().decode([String].self, from: result.data)
            })
            .receive(on: RunLoop.main)
            .mapError { APIError.parseError(reason: $0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
