# Build this image on a Python 3.12 image
#FROM python:3.12

#lightweight version of python
FROM python:3.12-slim 

#EXPOSE 5001

WORKDIR /server

# Copy requirements.txt in so that pip can access it
COPY requirements.txt requirements.txt

# Install the requirements.txt
RUN pip install -r requirements.txt

COPY . .

CMD ["python","server.py"]
