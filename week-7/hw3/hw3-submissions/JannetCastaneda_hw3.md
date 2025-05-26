# Homework 3 – Mtcars Flask API

**Student:** Jannet Castaneda Sanchez

**GitHub Repository:**  
[https://github.com/jannet1313/Mtcars-Flask-API](https://github.com/jannet1313/Mtcars-Flask-API)

**Cloud Run Endpoint:**  
[https://mtcars-flask-api-711427313394.us-central1.run.app/predict](https://mtcars-flask-api-711427313394.us-central1.run.app/predict)

---

## Description

This project builds and deploys a machine learning model as a REST API to predict miles per gallon (MPG) using the `mtcars` dataset. The model was trained in Python, wrapped in a Flask app, containerized with Docker, and deployed to Google Cloud Run.

The repo includes the trained model (`model.pkl`), Flask API (`app.py`), Docker configuration (`Dockerfile`), and `requirements.txt`. The app was tested both locally and via a deployed URL.

---

## Test Example

### Curl command:
```bash
curl -X POST https://mtcars-flask-api-711427313394.us-central1.run.app/predict \
  -H "Content-Type: application/json" \
  -d '{"cyl":6,"disp":160,"hp":110,"drat":3.9,"wt":2.62,"qsec":16.46,"vs":0,"am":1,"gear":4,"carb":4}'
