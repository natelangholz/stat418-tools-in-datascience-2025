[Isaac Schwarz - Homework 3](https://github.com/isaacfschwarz/mtcars-flask-API)

**Example `curl` Command:**

```{shell}
curl -X POST https://flask-api-linux-app-151633565461.europe-west1.run.app/predict \
  -H "Content-Type: application/json" \
  -d '{"cyl":6,"disp":160,"hp":110,"drat":3.9,"wt":2.62,"qsec":16.46,"vs":0,"am":1,"gear":4,"carb":4}'
```

**Example Output:**

`{"mpg_prediction":22.6}`