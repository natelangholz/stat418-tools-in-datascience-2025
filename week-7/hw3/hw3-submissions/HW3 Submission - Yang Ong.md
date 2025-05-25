### HW3 Submission - Yang Ong

**Repo:**
[Yang Ong - Homework 3 - Mtcars_Flask_Api](https://github.com/yangong17/Mtcars_Flask_Api)


**Example Curl Command:**

```
curl -X POST https://mtcars-flask-api-228019890474.us-central1.run.app/predict \
  -H "Content-Type: application/json" \
  -d '{
    "cyl": 6,
    "disp": 160,
    "hp": 110,
    "drat": 3.9,
    "wt": 2.62,
    "qsec": 16.46,
    "vs": 0,
    "am": 1,
    "gear": 4,
    "carb": 4
  }'
```