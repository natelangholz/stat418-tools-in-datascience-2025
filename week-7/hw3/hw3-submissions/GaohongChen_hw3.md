# Homework 3 Submission

**Name:** Gaohong Chen

**Subject:** Stat 418 HW3

## Repository Link:

[https://github.com/HenryC863/Mtcars_Flask_API](https://github.com/HenryC863/Mtcars_Flask_API)

## Curl Command for Flask API on Google Cloud:

```
curl -X POST https://mtcars-flask-app-693104809772.us-central1.run.app/predict_price \
-H "Content-Type: application/json" \
-d '{"cyl": 8, "disp": 360.0, "hp": 175, "drat": 3.15, "wt": 3.44, "qsec": 17.02, "vs": 0, "am": 0, "gear": 3, "carb": 2}'
```
