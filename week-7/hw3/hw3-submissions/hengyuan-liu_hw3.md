# Hengyuan (David) Liu – Homework 3 Submission

Repository: [Mtcars Flask API](https://github.com/DavidLiu0619/Mtcars-Flask-Api/)

This project builds a Flask API that serves a linear regression model trained on the `mtcars.csv` dataset. The application is containerized using Docker and deployed to **Google Cloud Run**. The repository includes setup instructions and test examples.

If the Flask API on Google Cloud Run is still active, you may test it using the following command:

# Test the Flask app running on Google Cloud Run
```
curl -X POST "https://mtcars-flask-app-980752141572.us-central1.run.app/predict_mpg" -H "Content-Type: application/json" -d '{"wt":3.73,"am":1,"qsec":17.6,"gear":4,"drat":3.07,"cyl":8}'
```