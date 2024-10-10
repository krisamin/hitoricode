//
//  ██   ██ ██████  ██ ███████  █████  ███    ███ ██ ███    ██
//  ██  ██  ██   ██ ██ ██      ██   ██ ████  ████ ██ ████   ██
//  █████   ██████  ██ ███████ ███████ ██ ████ ██ ██ ██ ██  ██
//  ██  ██  ██   ██ ██      ██ ██   ██ ██  ██  ██ ██ ██  ██ ██
//  ██   ██ ██   ██ ██ ███████ ██   ██ ██      ██ ██ ██   ████
//
//  https://isamin.kr
//  https://github.com/krisamin
//
//  Created : 10/10/24
//  Package : HitoriCode
//  File    : LandingWelcomeScreen.swift
//

import SwiftUI

struct LandingWelcomeScreen: View {
    let languages = ["English", "Korean"]
    @State var selectedLanguage = "English"

    var body: some View {
        NavigationStack {
            Spacer()
            Image("Hitori")
                .resizable()
                .frame(width: 160, height: 160)
            Spacer()
            Text("Welcome to HitoriCode")
                .font(.largeTitle)
            Text("Awesome macOS native code editor")
                .font(.title2)
            Spacer()
            Picker("Choose a Language", selection: $selectedLanguage) {
                ForEach(languages, id: \.self) {
                    Text($0)
                }
            }
            .labelsHidden()
            Spacer()
            HStack {
                NavigationLink("Getting Started") {
                    LandingFinishScreen()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
