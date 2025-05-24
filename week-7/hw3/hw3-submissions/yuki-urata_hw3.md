## Yuki Urata Homework 3 Submission

You can access the repo [here](https://github.com/yukiurt/Mtcars-Flask-Api).

If Google Cloud has not been shut, the Flask API could be checked by the code below.

```bash
curl -X POST "https://mtcars-flask-app-883217264014.us-west2.run.app/predict_mpg" -H "Content-Type: application/json" -d '{"cyl":"8","disp":"200","hp":"180","drat":"3.10","wt":"3.15","qsec":"20.0"}'
```
