//
//  ContentView.swift
//  MagiCo
//
//  Created by omer on 2.12.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var color1 = Color.red
    @State private var color2 = Color.blue
    @State private var mixRatio: Double = 0.5
    @State private var showCopiedAlert = false
    
    var mixedColor: Color {
        mixColors(color1: color1, color2: color2, ratio: mixRatio)
    }
    
    var hexCode: String {
        getHexCode(from: mixedColor)
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(colors: [.white, Color(.systemGray6)],
                          startPoint: .topLeading,
                          endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Title
                    Text("MagiCo")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.purple, .blue],
                                         startPoint: .leading,
                                         endPoint: .trailing)
                        )
                    
                    // Color Preview Card
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(mixedColor)
                            .frame(height: 200)
                            .shadow(radius: 10)
                        
                        VStack {
                            Spacer()
                            Text(hexCode)
                                .font(.system(.title2, design: .monospaced))
                                .bold()
                                .foregroundColor(isDarkColor(mixedColor) ? .white : .black)
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .cornerRadius(15)
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    // Color Pickers
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            ColorPickerView(selectedColor: $color1, title: "Color 1")
                            ColorPickerView(selectedColor: $color2, title: "Color 2")
                        }
                        
                        // Mix Ratio Slider
                        VStack(spacing: 8) {
                            Text("Mix Ratio")
                                .font(.headline)
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    // Gradient background for slider
                                    LinearGradient(colors: [color1, color2],
                                                 startPoint: .leading,
                                                 endPoint: .trailing)
                                        .cornerRadius(10)
                                    
                                    Text("\(Int(mixRatio * 100))%")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .frame(width: geometry.size.width * CGFloat(mixRatio), alignment: .trailing)
                                }
                            }
                            .frame(height: 20)
                            .overlay {
                                Slider(value: $mixRatio)
                                    .tint(.clear)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 5)
                    )
                    .padding(.horizontal)
                    
                    // Copy Button
                    Button(action: {
                        UIPasteboard.general.string = hexCode
                        showCopiedAlert = true
                        
                        // Hide the alert after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showCopiedAlert = false
                        }
                    }) {
                        Label("Copy Hex Code", systemImage: "doc.on.doc")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: [.purple, .blue],
                                             startPoint: .leading,
                                             endPoint: .trailing)
                            )
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            
            // Copied Alert
            if showCopiedAlert {
                VStack {
                    Spacer()
                    Text("Copied to clipboard!")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 50)
                }
                .animation(.spring, value: showCopiedAlert)
            }
        }
    }
    
    func mixColors(color1: Color, color2: Color, ratio: Double) -> Color {
        guard let components1 = color1.cgColor?.components,
              let components2 = color2.cgColor?.components else {
            return .black
        }
        
        let r = components1[0] * (1 - ratio) + components2[0] * ratio
        let g = components1[1] * (1 - ratio) + components2[1] * ratio
        let b = components1[2] * (1 - ratio) + components2[2] * ratio
        
        return Color(red: r, green: g, blue: b)
    }
    
    func getHexCode(from color: Color) -> String {
        guard let components = color.cgColor?.components else { return "#000000" }
        
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    func isDarkColor(_ color: Color) -> Bool {
        guard let components = color.cgColor?.components else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness < 0.5
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedColor)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(.gray.opacity(0.2))
                    )
                
                ColorPicker(title, selection: $selectedColor)
                    .labelsHidden()
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .padding(5)
            }
        }
    }
}

#Preview {
    ContentView()
}
