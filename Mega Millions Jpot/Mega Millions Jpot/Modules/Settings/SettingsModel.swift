//
//  SettingsModel.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 09.01.2025.
//


import SwiftUI

class SettingsModel: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
}
