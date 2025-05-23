# Yifan Shen — Homework 3

**GitHub repo:** https://github.com/michaelshen25/Mtcars_Flask_Api  
**Live API endpoint:** https://mtcars-api-609056186247.us-central1.run.app/predict

**Example request:**
```bash
curl -X POST https://mtcars-api-609056186247.us-central1.run.app/predict \
  -H "Content-Type: application/json" \
  -d '{"cyl":6,"disp":160,"hp":110,"drat":3.9,"wt":2.62,"qsec":16.46,"vs":0,"am":1,"gear":4,"carb":4}'
