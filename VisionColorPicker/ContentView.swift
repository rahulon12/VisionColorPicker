//
//  ContentView.swift
//  VisionColorPicker
//
//  Created by Rahul on 9/19/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var color = Color.white
    @State private var brightness: CGFloat = 1.0
    @State private var saturation: CGFloat = 1.0

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8.0)
                .fill(color)
                .frame(width: 100, height: 100)
            VStack {
                CustomColorPickerWheel(
                    bgColor: $color,
                    brightness: $brightness,
                    saturation: $saturation
                )
                
                SaturationSlider(value: $saturation, color: color)
                    .frame(width: 500, height: 50)
            }
            .padding()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
