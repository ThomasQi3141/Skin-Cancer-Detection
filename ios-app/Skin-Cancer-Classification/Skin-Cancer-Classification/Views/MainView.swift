import SwiftUI
import PhotosUI

struct MainView: View {
    @StateObject private var viewModel = ImagePickerViewModel()
    @State private var showingImagePicker = false
    @State private var isUsingImagePicker = true
    @State private var isLoading = false
    @State private var predictionResult: String?
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            VStack {
                
                // Subtitle
                Text(isUsingImagePicker ? "Select an Image" : "Take a Photo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5) // Scale text to fit
                    .padding()
                
                Spacer()
                
                if isUsingImagePicker {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        Button("Get Prediction") {
                            getPrediction()
                        }
                        .padding()
                        .disabled(isLoading)
                    } else {
                        Text("No Image Selected")
                    }

                    Button("Import Image") {
                        showingImagePicker = true
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(selectedImage: $viewModel.selectedImage)
                    }
                    
                    if let result = predictionResult {
                        Text("Prediction: \(result)")
                            .font(.headline)
                            .padding()
                    }
                } else {
                    Text("Take a Photo") // Placeholder for camera view
                }

                Spacer()
                
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isUsingImagePicker.toggle()
                    }) {
                        Image(systemName: isUsingImagePicker ? "photo.on.rectangle.angled" : "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(8)
                            .background(Color.white.opacity(0.8), in: Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
            
            if isLoading {
                ProgressView("Retrieving Prediction...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
    }

    private func getPrediction() {
        guard let selectedImage = viewModel.selectedImage else {
            print("No image selected.")
            return
        }

        isLoading = true

        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
                print("Failed to compress image.")
                return
            }
            let base64String = imageData.base64EncodedString()
            let url = URL(string: Config.apiUrl)!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["imageData": base64String]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    isLoading = false
                }

                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        errorMessage = "An error occurred: \(error.localizedDescription)"
                    }
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 413 {
                        print("Error: The image is too large to be processed by the server.")
                        DispatchQueue.main.async {
                            errorMessage = "Image is too large. Please use a smaller image."
                        }
                        return
                    } else {
                        print("HTTP Response Status Code: \(httpResponse.statusCode)")
                    }
                }

                guard let data = data else {
                    print("No data received.")
                    return
                }

                do {
                    if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let prediction = result["prediction"] as? String {
                        DispatchQueue.main.async {
                            predictionResult = prediction
                        }
                    } else {
                        print("Failed to parse JSON response.")
                        DispatchQueue.main.async {
                            errorMessage = "Failed to parse server response."
                        }
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        errorMessage = "Failed to parse response: \(error.localizedDescription)"
                    }
                }
            }
            task.resume()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
