// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI



// TODO: сделать нормальный UX

@available(iOS 15.0, *)
struct PickerUI: View {
    let  radius: CGFloat = 100
    var diameter: CGFloat {
        radius * 2
    }
    @State private var startLocation: CGPoint?
    
    @State private var location: CGPoint?
    
    @State private var brightness: Double = 0.5
    
    @Binding var bgColor: Color
    
    @Environment(\.dismiss) var dismiss
    

    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Circle()
                        .frame(width: 40)
                        .foregroundStyle(bgColor)
                        
                    Text(bgColor.toHex())
                    Spacer()
                }
                .padding()
                
                
                HStack {
                    Text("Яроксть палитры:")
                    Slider(value: $brightness, in: 0.0...1.0, step: 0.01)
                }
                
                
                ZStack {
                    
                    Text("Нажми здесь, чтобы выбрать цвет")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .opacity(0.4)
                    
                    if startLocation != nil {
                        Circle()
                            .fill(
                        AngularGradient (gradient: Gradient (colors: [
                            Color(hue: 1.0, saturation: 1, brightness: brightness),
                            Color(hue: 0.9, saturation: 1, brightness: brightness),
                            Color(hue: 0.8, saturation: 1, brightness: brightness),
                            Color(hue: 0.7, saturation: 1, brightness: brightness),
                            Color(hue: 0.6, saturation: 1, brightness: brightness),
                            Color(hue: 0.5, saturation: 1, brightness: brightness),
                            Color(hue: 0.4, saturation: 1, brightness: brightness),
                            Color(hue: 0.3, saturation: 1, brightness: brightness),
                            Color(hue: 0.2, saturation: 1, brightness: brightness),
                            Color(hue: 0.1, saturation: 1, brightness: brightness),
                            Color(hue: 0.0, saturation: 1, brightness: brightness)
                            
                            
                            
                            
                            ]), center: .center)
                        )
                            .frame(width: diameter, height: diameter)
                            .overlay(
                                
                                Circle()
                                    .fill(
                                        RadialGradient(gradient: Gradient(colors: [
                                            Color.white,
                                            Color.white.opacity(0.000001)
                                        ]), center: .center, startRadius: 0, endRadius: radius)
                                    )
                            )
                            .position(startLocation!)
                        
                        
                        Circle()
                            .frame (width: 50, height: 50)
                            .position(location!)
                            .foregroundColor(.white)
        //                    .ignoresSafeArea()
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .gesture(dragGesture)
                
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("закрыть") {
                            dismiss()
                        }
                     }
                }
            }
            .background(.white)
            
        }
    }
    
    var dragGesture: some Gesture
    {
        DragGesture (minimumDistance: 0)
            .onChanged { val in
                if startLocation == nil {
                    startLocation = val.location
                }
                
//                location = val.location
                
                let distanceX = val.location.x - startLocation!.x
                let distanceY = val.location.y - startLocation!.y
                
                let dir = CGPoint(x: distanceX, y: distanceY)
                var distance = sqrt(distanceX * distanceX + distanceY * distanceY)
                
                if distance < radius {
                    location = val.location
                } else {
                    let clampedX = dir.x / distance * radius
                    let clampedY = dir.y / distance * radius
                    location = CGPoint(x: startLocation!.x + clampedX,
                                       y: startLocation!.y + clampedY)
                    distance = radius
                }
                
                // if
               
                if distance == 0 { return }
                var angle = Angle(radians: -Double(atan(dir.y / dir.x)))
                
                if dir.x < 0 {
                    angle.degrees += 180
                }
                
                else if dir.x > 0 && dir.y > 0 {
                    angle.degrees += 360
                }
                    
                let hue = angle.degrees / 360
                let saturation = Double(distance / radius)
                
                bgColor = Color(hue: hue, saturation: saturation, brightness: brightness)
            }
            .onEnded { val in
                startLocation = nil
                location = nil
            }
    }
}

@available(iOS 14.0, *)
extension Color {
    
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else {
            return ""
        }
        
        let red = String(format: "%02lX", Int(components[0] * 255.0))
        let green = String(format: "%02lX", Int(components[1] * 255.0))
        let blue = String(format: "%02lX", Int(components[2] * 255.0))
        
        return "#\(red)\(green)\(blue)"
    }
}
