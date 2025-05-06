# Build this image on a Python 3.12 image
#FROM python:3.12

#lightweight version of python
FROM python:3.12-slim 

# Upgade pip
#RUN pip install --upgrade pip

# Copy requirements.txt in so that pip can access it
COPY requirements.txt /home/requirements.txt

# Install the requirements.txt
RUN pip install -r /home/requirements.txt

CMD ["python","/scripts/server.py"]
