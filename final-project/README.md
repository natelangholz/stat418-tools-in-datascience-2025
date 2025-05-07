# Final Project: Create a Data/ML/AI Application


## Project Description

The STAT 418 final project will be to an useable application with connectivity to a deployed 'model' and doing a short demo. This requires taking a project from conception to completion including:
* data collection
* building a model,
* interactive interface that is hosted on the cloud through way of Shiny (python or R) application. 
* cloud hosted model API that your Shiny app will connect to.
* a Docker Image (will be shown in class in a few weeks).

Create a stand alone github repo for your project that will show the progress of your work and stand as a stand-alone project (and repo) that you can show outside of class if necessary. 

Data should be collected through a web scraping process whether it be through an API or scraping the html files themselves. You can pull it however you like but make a nice tabular dataset (if text or images have a reference to the image with other metadata info as other columns) from which you can build a simple model. 

The modeling piece doesn't have to be overly complicated if you don't want it to be. That is not the focus of this course. A multiple regression or classification model will suffice. Of course something a bit more complex in comparison to a simple baseline model will be a bit more intriguing to talk after this course concludes.

Additionally, the 'model' itself doesn't have to be overly complex but make it something that you would like to show after this course concludes. Simple can tell a strong message,  Really this should be something that I or your classmates can interact with in some way whether it be dropdown menu to change values in a Shiny app or adding new values to make predictions through an API. (see Deployment below) I know without having the current knowledge of how to create any of these things this sounds like a difficult undertaking but hopefully we will learn enough in the coming weeks to make something useful. Bring it all together in a writeup explaining what you did and how to replicate it. Do this through your Github repo so that someone else who comes across it can understand the process you have to complete your project. Create a README.md file explaining what the project is and then additional directories (also with explanation READMEs) that contain your code, presentations, and any additional files of interest.

### Proposal Presentation

Slide submissions for the proposal presentation will be available until **11:59 am May 6, 2025**. Create a pull request to the corresponding Github directory. 

There is a proposal presentation component that will happen during week 6 for 3-4 minutes each. No more or no less. There will be a maximum of 4 slides; 1 title slide and then 3 with content. This should only show your work in attaining a dataset, light exploratory data analysis, and a proposal of what you intend to do with the data and what 'product' you might build (this can change by the final presentation, so don't work if you aren't 100% sure with what you want to do). Order of presentations will be randomized. 

To that end you will need to start collecting your data prior to week six. Create your project GitHub repo. Both week 3 and 4 have shown different methods to collect data from websites.  Adapt these methods to do so for your project. It may not be the case that you have completed your data collection at this point but be well on your way to doing so. 

### Final Presentation

Slide submissions for the proposal presentation will be available until **11:59 pm June 2, 2025**. Create a pull request to the corresponding Github directory. 

There is also a presentation component that will happen final class period for 4-5 minutes each. No more or no less. Here there will be a maximum of 5 slides; 1 title slide and then 4 (or less) with content. Order of presentations will be randomized. 

A final writeup with exploratory data analysis, methodology, and results should be present on your Github repo. This will be assessed; make your Github repo so that someone else who comes across it can understand the process you have to complete your project. Create a README.md file explaining what the project is and then additional directories (also with explanation READMEs) that contain your code, presentations, and any additional files of interest.

### Deployment

The final application should be deployed as somewhere a service online so that I and anyone of your classmates can visit or interact with it from their machines with a correct example or instructions. The Shiny App should behosted on shinyapps.io or Amazon ec2 (tbd) and the model api can be created through plumber or flask and hosted on Amazon ec2 (tbd). This should be available for interaction at least through week 10 until **June 10, 2025** anyone to test (including me). With the amount free resources on Amazon ec2 and on shinyapps.io it should be sufficient to run deployed for a week.  Once that week has passed feel free to take it down. A working service will be part of the grade of this project. 

### Examples

Here are a few nice examples of past github repos from this course in past iterations. 

[International Airfare Price Predictions](https://github.com/chenjoyq/intl-airfare-pricing) - Joy Chen

[Daily Fantasy Optimizer](https://github.com/guydotan/nfl-dfs-optimizer) - Guy Dotan

[Gaming the System](https://github.com/RIPsilon/418-Final-Project/tree/master) - Anna Huynh
