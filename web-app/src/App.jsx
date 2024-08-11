import React, { useState, useRef } from "react";
import axios from "axios";
import "./App.css";
import Footer from "./Components/Footer";

const App = () => {
  const [image, setImage] = useState(null);
  const [result, setResult] = useState(null);
  const [clicked, setClicked] = useState(false);
  const [cameraOn, setCameraOn] = useState(false);
  const videoRef = useRef(null);
  const canvasRef = useRef(null);

  const handleImageChange = (event) => {
    setImage(event.target.files[0]);
  };

  const getPrediction = async () => {
    if (image === null) {
      alert("No File Chosen");
    } else {
      try {
        setClicked(true);
        let url = JSON.stringify(import.meta.env["VITE_REACT_API_URL"]);
        url = url.substring(1, url.length - 1);

        const reader = new FileReader();
        reader.onloadend = async () => {
          const base64String = reader.result;

          try {
            const response = await axios.post(
              url,
              { imageData: base64String },
              {
                headers: {
                  "Content-Type": "application/json",
                },
              }
            );
            setResult(response.data);
          } catch (error) {
            console.error("Error:", error);
          }
          setClicked(false);
        };
        reader.readAsDataURL(image);
      } catch (error) {
        console.error("Error:", error);
      }
    }
  };

  const handleCameraToggle = () => {
    if (!cameraOn) {
      navigator.mediaDevices
        .getUserMedia({ video: true })
        .then((stream) => {
          videoRef.current.srcObject = stream;
        })
        .catch((err) => {
          console.error("Error accessing the camera:", err);
        });
      setCameraOn(true); // Move this out of the .then() block
    } else {
      let stream = videoRef.current.srcObject;
      let tracks = stream.getTracks();

      tracks.forEach((track) => track.stop());
      videoRef.current.srcObject = null;
      setCameraOn(false);
    }
  };

  const takePhoto = () => {
    const context = canvasRef.current.getContext("2d");
    context.drawImage(videoRef.current, 0, 0, 600, 450);
    canvasRef.current.toBlob((blob) => {
      setImage(blob);
    }, "image/jpeg");
    handleCameraToggle();
  };

  return (
    <>
      <h1>Skin Cancer Classification</h1>
      <h2>Take a Photo of the Skin Lesion</h2>

      {cameraOn && (
        <>
          <div className="wrapper">
            <div className="video-wrapper">
              <div className="wrapper">
                <div className="video-text">
                  Place the Skin Lesion Within the Circle
                </div>
              </div>
              <video ref={videoRef} width="600" height="450" autoPlay />
              <div className="circle-div"></div>
            </div>
          </div>
        </>
      )}

      <div className="button-wrapper">
        {cameraOn && (
          <button className="button-17" onClick={takePhoto}>
            Take Photo
          </button>
        )}
      </div>
      <div className="wrapper">
        {cameraOn ? (
          <button className="button-17" onClick={handleCameraToggle}>
            Camera Off
          </button>
        ) : (
          <button className="button-17" onClick={handleCameraToggle}>
            Camera On
          </button>
        )}
      </div>

      <h2>Or Upload a Photo (Only Accepts .jpg Files)</h2>
      <div className="wrapper">
        <input
          type="file"
          onChange={handleImageChange}
          className="file-upload"
        />
      </div>
      <div className="wrapper">
        {!clicked ? (
          <button className="button-17" onClick={getPrediction}>
            Get Prediction
          </button>
        ) : (
          <>
            <div className="loader"></div>
            <div className="loading-text">Retrieving Prediction...</div>
          </>
        )}
      </div>
      <div className="wrapper">
        {result && (
          <div className="prediction-text">
            Prediction: {result["prediction"]}
          </div>
        )}
      </div>
      <canvas
        ref={canvasRef}
        style={{ display: "none" }}
        width="600"
        height="450"
      ></canvas>
      <Footer textColor={"white"}>
        &copy; {new Date().getFullYear()} Thomas Qi. All rights reserved.
      </Footer>
    </>
  );
};

export default App;
