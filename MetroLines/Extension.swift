//
//  Extension.swift
//  MetroLines
//
//  Created by Chatharoo on 30/06/2020.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 225/255, green: 225/255, blue: 235/255)
}

extension View {
    @inlinable public func neumorphicShadowBlack(color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        
            return shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
    }
    
    @inlinable public func neumorphicShadowWhite(color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        
            return shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }
}
