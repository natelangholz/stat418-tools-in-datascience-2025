# Timothy Tu Final Project Submission

You can find my github for the final project [here](https://github.com/myosotismenot/Air-Quality-Prediction).

## Test quickly instead of viewing/downloading github

The link to the shiny app hosted (separately) on google cloud run can be found [here](https://rfshiny-1099088179937.us-central1.run.app/)

As long as I have not taken down the final project (expect by end of Spring 2025 quarter), you can test the flask api portion via this command.

```
curl -X POST https://rf-aqi-1099088179937.us-central1.run.app/predict \
  -H "Content-Type: application/json" \
  -d '{"temp": 25, "precip": 0, "humidity": 60, "cloud": 30}'
```

with the expected output being 

```
{
  "pm2_5_prediction": 19.0
}
```
