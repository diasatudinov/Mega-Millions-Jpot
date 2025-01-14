//
//  Links.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 13.01.2025.
//


import SwiftUI

class Links {
    
    static let shared = Links()
    
    static let winStarData = "https://rainbowcrafter.pro/chest"
    //"?page=test"
    
    @AppStorage("finalUrl") var finalURL: URL?
    
    
}
