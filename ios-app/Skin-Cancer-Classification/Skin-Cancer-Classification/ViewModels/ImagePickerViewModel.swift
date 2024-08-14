import SwiftUI
import UIKit

class ImagePickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var result: String?
    @Published var isLoading: Bool = false
    
    private let apiUrl = "https://sentiment-analysis.nard.ca/classify_image"
    
    func getPrediction() {
        guard let image = selectedImage else {
            print("No image selected")
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 1.0)?.base64EncodedString() else {
            print("Could not encode image")
            return
        }
        
        isLoading = true
        
        let url = URL(string: apiUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["imageData": imageData]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let result = try? JSONDecoder().decode([String: String].self, from: data) {
                DispatchQueue.main.async {
                    self?.result = result["prediction"]
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}
