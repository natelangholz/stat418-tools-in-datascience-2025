# Derek Wen — Homework 3 Submission

**GitHub repo:** [Derek Wen - Homework 3](https://github.com/Derek-Wen/Mtcars-Flask-Api)
**Docker Hub image:** https://hub.docker.com/r/derekhwen/mtcars-flask-api
**Cloud Run URL:** https://mtcars-flask-api-427327765085.us-central1.run.app

```bash
curl -X POST "https://mtcars-flask-api-427327765085.us-central1.run.app/predict" \
  -H "Content-Type: application/json" \
  -d '{"cyl":6,"disp":160.0,"hp":110,"drat":3.90,"wt":2.620,"qsec":16.46,"vs":0,"am":1,"gear":4,"carb":4}'
```