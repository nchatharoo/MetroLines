//
//  AsyncImage.swift
//  WhereToWatch
//
//  Created by Chatharoo on 24/06/2020.
//  Copyright © 2020 Chatharoo. All rights reserved.
//

import Foundation
import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var imageLoader: ImageLoader
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image
    
    init(url: URL, placeholder: Placeholder? = nil, cache: ImageCache? = nil, configuration: @escaping(Image) -> Image = { $0 }) {
        imageLoader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
    }
    
    var body: some View {
        image
            .onAppear(perform: imageLoader.fetchImage)
            .onDisappear(perform: imageLoader.cancel)
    }
    
    private var image: some View {
        Group {
            if imageLoader.image != nil {
                configuration(Image(uiImage: imageLoader.image!))
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}
