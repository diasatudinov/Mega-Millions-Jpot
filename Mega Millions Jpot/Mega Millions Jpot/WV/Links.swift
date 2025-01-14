import SwiftUI

class Links {
    
    static let shared = Links()
    
    static let winStarData = "https://rainbowcrafter.pro/chest"
    //"?page=test"
    
    @AppStorage("finalUrl") var finalURL: URL?
    
    
}
