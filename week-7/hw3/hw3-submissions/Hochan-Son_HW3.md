# HW3 Submission
```
S25-STATS418-HW3
Author: Hochan Son
Date: 05-18-25
```

### Homework3 Work flow
* [x] Create a standalone github repo called `Mtcars Flask Api`. Use the mtcars.csv dataset to create a predictive linear model using `mpg` as a response and any (or all) other remaining variables as predictors using Python in a Docker container. 

* [x] With the predictive model create a flask API (first locally) that is functional using a Docker container, push the image to DockerHub, and then deploy to Google Cloud Run. Someone else should be able to stumble across your repo, clone it, and reproduce.

* [x] This github repo should contain a README explaining what is included in the repo and what is being done.

* [x] There should also be directions (possibly in another README in another directory) on how to standup your API. Provide an example input and output (as curl command), so that if I run, calling the API, I will get the same results when I call your deployed model. 

### Link for HW submission
Mtcars-Flask-API (https://github.com/ohsono/Mtcars-Flask-Api)
Cloud Run(https://mtcars-api-793212150918.us-west2.run.app)
Docker Hub(docker.io/ohsonoresearch/mtcars-api:latest)

```bash
(base)  hobangu@Mac  ~  curl https://mtcars-api-793212150918.us-west2.run.app/predict \
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
Response:
```json
{
  "features_used": [
    "cyl",
    "disp",
    "hp",
    "drat",
    "wt",
    "qsec",
    "vs",
    "am",
    "gear",
    "carb"
  ],
  "predicted_mpg": 21.878958945281678
}
```
