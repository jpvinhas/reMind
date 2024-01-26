//
//  reLaunchScreen.swift
//  reMind
//
//  Created by João Pedro Borges on 24/01/24.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [
                    Palette.aquamarine.render,
                    Palette.lavender.render,
                    Palette.mauve.render
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            Text("reMind")
                .font(Font.system(size: 70, weight: .bold, design: .default))
                .foregroundColor(.black)
                .padding()
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}

