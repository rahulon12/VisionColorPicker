//
//  SaturationSlider.swift
//  VisionColorPicker
//
//  Created by Rahul on 9/19/24.
//

import SwiftUI

struct SaturationSlider: View {
    @Binding var value: CGFloat
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Dynamic gradient track background
                LinearGradient(gradient: Gradient(colors: [Color.white, color]),
                               startPoint: .leading,
                               endPoint: .trailing)
                    .mask(Capsule())

                // Circular thumb
                Circle()
                    //.frame(width: 20, height: 20)
                    .foregroundColor(color)
                    .overlay(Circle().stroke(Color.black.opacity(0.5), lineWidth: 2))
                    .offset(x: thumbPosition(geometry: geometry))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // Calculate slider value based on drag position
                                let newValue = min(max(0, value.location.x / geometry.size.width), 1)
                                self.value = newValue
                            }
                    )
            }
        }
    }

    // Helper function to calculate thumb position
    private func thumbPosition(geometry: GeometryProxy) -> CGFloat {
        return CGFloat(value) * geometry.size.width - 35 // Center the thumb
    }
}
