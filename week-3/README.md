# Week 3

## Week Overview

We talk about the Unix operating system. Time permitting we will begin looking at web scraping through [The New York Times Developer Network](https://developer.nytimes.com) API.

So that we all are using the same environment we will use a Docker Image for the book [Data Science at the Command Line](https://www.datascienceatthecommandline.com/index.html) by Jeroen Janssens, version 1, which is not the same image at the link. The following commands pull the image v1 from dockerhub. 

First we need to pull the image using the following:

`docker pull jeroenjanssens/data-science-at-the-command-line`

Then to run the image

`docker run --rm -it jeroenjanssens/data-science-at-the-command-line`

To leave the environment simply type `exit`

Now to mount your local directory as a volume using the following commands

On a Mac:
`docker run --rm -it -v "$(pwd)":/data jeroenjanssens/data-science-at-the-command-line`

In Windows command line
`docker run --rm -it -v "%cd%":/data jeroenjanssens/data-science-at-the-command-line`

In Windows powershell 
`docker run --rm -it -v ${PWD}:/data jeroenjanssens/data-science-at-the-command-line`

-----
Also, the data will need to be downloaded from:
(https://www.datascienceatthecommandline.com/2e/data.zip)

And placed in a directory where you can access. 

## Resources

[Slides](https://github.com/natelangholz/stat418-tools-in-datascience-2025/blob/master/week-3/slides-week-3.pdf)

-----

This Docker Image for the Unix environment we will use as a class came from this book

[Data Science at the Command Line](https://www.datascienceatthecommandline.com/index.html) by Jeroen Janssens.

We won't be using all the resources from this book nor going through all the chapters but I suggest doing so outside of this course. They are valuable tools that will only improve your productivity as a Data Scientist.

Another useful book [Command line basics for R Users](https://bash-intro.rsquaredacademy.com/r-command-line)

-----

[Command Line Confessions](https://hackernoon.com/command-line-confessions-the-embarrassing-questions-i-should-have-asked-long-ago), Hackernoon, Daria Leonova

[Interesting New York Times article - Facial Recognition in NYC](https://www.nytimes.com/interactive/2019/04/16/opinion/facial-recognition-new-york-city.html?action=click&module=Opinion&pgtype=Homepage) by Sahil Chinoy

