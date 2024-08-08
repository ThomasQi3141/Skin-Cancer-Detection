from flask import Flask, request, jsonify
from flask_cors import CORS
from keras.models import load_model
import numpy as np
import base64
from PIL import Image
from io import BytesIO

app = Flask(__name__)
CORS(app)  # Enable CORS

# Load the model
model = load_model('saved_models/model_acc_0.983.h5')

@app.route('/classify_image', methods=['POST'])
def classify_image():
    data = request.json
    image_data = data['imageData']
    
    # Remove the 'data:image/jpeg;base64,' prefix if it exists
    if image_data.startswith('data:image/jpeg;base64,'):
        image_data = image_data.replace('data:image/jpeg;base64,', '')

    # Decode the base64 string to bytes
    image_bytes = base64.b64decode(image_data)
    
    # Convert bytes to a PIL Image
    image = Image.open(BytesIO(image_bytes))
    
    # Resize image to the expected size (28, 28)
    image = image.resize((28, 28))
    
    image_RGB = image.convert('RGB')
    
    # Convert image to numpy array
    image_array = np.array(image_RGB)
    
    if image_array.shape[2] == 4:  # If there is an alpha channel (transparency)
        image_array = image_array[:, :, :3]  # Remove alpha channel
    
    # Expand dimensions to match the input shape of the model
    image_array = np.expand_dims(image_array, axis=0)

    # Make prediction
    prediction = np.argmax(model.predict(image_array))
    
    classes = {
        4: 'Melanocytic Nevi',
        6: 'Melanoma',
        2: 'Benign Keratosis-like Lesions', 
        1: 'Basal Cell Carcinoma',
        5: 'Pyogenic Granulomas and Hemorrhage',
        0: 'Actinic Keratoses and Intraepithelial Carcinomae',
        3: 'Dermatofibroma'
    }
    
    # Return prediction as a class
    return jsonify({"prediction": classes[prediction]})

if __name__ == '__main__':
    app.run(debug=True)
