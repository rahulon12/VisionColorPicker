//
//  CustomColorPickerWheel.swift
//  ColorPlaygroundVision
//
//  Created by Rahul on 9/8/24.
//

import SwiftUI

struct CustomColorPickerWheel: View {
    @Binding var bgColor: Color
    @Binding var brightness: CGFloat
    @Binding var saturation: CGFloat

    @State private var center: CGPoint?
    @State private var knobLocation: CGPoint?

    @State private var radius: CGFloat = 100


    var body: some View {
        ZStack {
            if let center {
                ColorWheel(
                    brightness: brightness,
                    saturation: saturation,
                    radius: radius
                )
                    .frame(width: diameter, height: diameter)
                    .position(center)

                Circle()
                    .fill(bgColor)
                    .stroke(.white)
                    .frame(width: 75, height: 75)
                    .position(knobLocation!)
            }
        }
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            radius = min(newValue.width / 2 - 16, newValue.height / 2 - 16)
            center = newValue.center
            knobLocation = newValue.center
            bgColor = calculateColor()
        }
        .onChange(of: saturation) { newValue in
            bgColor = calculateColor()
        }
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(dragGesture)
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                knobLocation = value.location
                bgColor = calculateColor()
            }
    }

    private func calculateColor() -> Color {
        let distanceX = knobLocation!.x - center!.x
        let distanceY = knobLocation!.y - center!.y

        let dir = CGPoint(x: distanceX, y: distanceY)

        var distance = sqrt(pow(dir.x, 2) + pow(dir.y, 2))

        if distance >= radius {
            let clampedX = dir.x / distance * radius
            let clampedY = dir.y / distance * radius

            knobLocation = CGPoint(x: center!.x + clampedX, y: center!.y + clampedY)
            distance = radius
        }

        if distance == 0 {
            return .white
        }

        var angle = Angle(radians: -Double(atan2(dir.y, dir.x)))
        if angle.degrees < 0 {
            angle.degrees += 360
        }

        let hue = angle.degrees / 360
        let saturation = Double(distance / radius) * self.saturation

        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }

    var diameter: CGFloat { radius * 2 }
}

private struct ColorWheel: View {
    let brightness: CGFloat
    let saturation: CGFloat
    let radius: CGFloat

    var body: some View {
        Circle()
            .fill(
                AngularGradient(
                    gradient: .init(colors: [
                        Color(hue: 1.0, saturation: saturation, brightness: brightness),
                        Color(hue: 0.9, saturation: saturation, brightness: brightness),
                        Color(hue: 0.8, saturation: saturation, brightness: brightness),
                        Color(hue: 0.7, saturation: saturation, brightness: brightness),
                        Color(hue: 0.6, saturation: saturation, brightness: brightness),
                        Color(hue: 0.5, saturation: saturation, brightness: brightness),
                        Color(hue: 0.4, saturation: saturation, brightness: brightness),
                        Color(hue: 0.3, saturation: saturation, brightness: brightness),
                        Color(hue: 0.2, saturation: saturation, brightness: brightness),
                        Color(hue: 0.1, saturation: saturation, brightness: brightness),
                        Color(hue: 0.0, saturation: saturation, brightness: brightness)
                    ]),
                    center: .center
                )
            )
            .overlay {
                Circle()
                    .fill(
                        .radialGradient(
                            .init(colors: [.white, .white.opacity(0.0000001)]),
                            center: .center,
                            startRadius: 0,
                            endRadius: radius
                        )
                    )
            }
    }
}

extension CGSize {
    var center: CGPoint {
        CGPoint(x: width / 2, y: height / 2)
    }
}

#Preview {
    @Previewable @State var bgColor: Color = .white
    CustomColorPickerWheel(
        bgColor: $bgColor,
        brightness: .constant(1.0),
        saturation: .constant(1.0)
    )
}
