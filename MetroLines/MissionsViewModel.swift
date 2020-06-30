//
//  MissionsViewModel.swift
//  MetroLines
//
//  Created by Chatharoo on 30/06/2020.
//

import Foundation
import Combine
import SwiftUI

final class MissionsViewModel : ObservableObject {
    @Published var results: [String] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        APIService.fetch()
             .sink(receiveCompletion: { completion in
                 if case .failure(let apiError) = completion {
                     print(apiError)
                 }
             }, receiveValue: { (model: [String]) in
                 print(model)
                 self.results = model
             }).store(in: &cancellables)
    }
}


