# Skin Cancer Detection Model

### Test out the model using the web-app <a href="https://prod.d2sxo0mkrus18x.amplifyapp.com/" target=”_blank”>here</a>!

### The dataset used to train the model can be found <a href="https://www.kaggle.com/datasets/kmader/skin-cancer-mnist-ham10000" target=”_blank”>here</a>

## Abstract

With over 330,000+ cases of diagnosed skin cancer every year, skin cancer is becoming one of the most common cancer types. Every year, millions of dollas worth of equipment is spent trying to detect, classify, and predict the behvaiour of skin lesions. This project aims to leverage computer vision and deep learning to provide a custom solution to streamline the process of skin cancer diagnosis. The final model has a training and testing accuracy of 99.4% and 98.3% (F1 Score), and is lightweight enough to predict in real-time. 


## iOS App Screenshots:

<div style="display: flex; flex-direction: row;">
    <img src="https://github.com/user-attachments/assets/2060b5cb-ea20-4b47-8e35-dbfd0275e3ca" width="432" alt="Screenshot 1">
    <img src="https://github.com/user-attachments/assets/1c6e1484-008d-499e-bb05-794a9bf2e6e1" width="432" alt="Screenshot 2">
</div>


### Tools/Technologies Used:
<ul>
  <li><a href="https://www.tensorflow.org/">TensorFlow</a></li>
  <li><a href="https://keras.io/">Keras</a></li>
  <li><a href="https://scikit-learn.org/stable/">Scikit-Learn</a></li>
  <li><a href="https://react.dev/">React.js</a></li>
  <li><a href="https://developer.apple.com/swift/">Swift</a></li>
  <li><a href="https://flask.palletsprojects.com/en/3.0.x/">Flask</a></li>
  <li><a href="https://numpy.org/">NumPy</a></li>
  <li><a href="https://pandas.pydata.org/">Pandas</a></li>
  <li><a href="https://nginx.org/en/">nginx</a></li>
  <li><a href="https://gunicorn.org/">Gunicorn</a></li>
  <li><a href="https://aws.amazon.com/ec2/">AWS EC2</a></li>
  <li><a href="https://aws.amazon.com/amplify" target="_blank">AWS Amplify</a></li>
</ul>


## Files
`model.ipynb`: The Jupyter Notebook containing the code used to train the model <br />
`/model/`: The folder containing the code for the model <br />
`/web-app/`: The React front-end for the web-app <br />
`/ios-app/`: The Swift front-end for the iOS-app <br />
`/server/`: The Flask back-end for the app <br />
`requirements.txt`: The packages required to run the code to train the model<br />


## To-Use
Since the final model was too big to upload to github, you would have to train the model locally. To do so, you can install the prerequisites using `requirements.txt` and locally train the model using the code from `/model`, saving it as a `.h5` file. 

### Installation:

1. Clone the repo
   ```sh
   git clone https://github.com/ThomasQi3141/Skin-Cancer-Detection
   ```
2. Install required packages
   ```sh
   $ pip install -r requirements.txt
   ```
3. Run the code in `model.ipynb`


