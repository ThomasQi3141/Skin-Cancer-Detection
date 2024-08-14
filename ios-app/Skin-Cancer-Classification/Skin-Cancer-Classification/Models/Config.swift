import Foundation

struct Config {
    static var apiUrl: String {
        guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist["API_URL"] as? String else {
            fatalError("Couldn't find key 'API_URL' in 'Config.plist'.")
        }
        return value
    }
}
