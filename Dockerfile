# If we do not have to run this container on Windows OS we can use python:<version>alpine.
# But if we have to make this project support all OS we have to use an image like python:3 but its size is big.

FROM python:3.10-rc-alpine

WORKDIR /usr/src/app

# Make sure to copy needed files only.In this project we use .dockerignore do we can Copy all files.

COPY app.py requirements.txt /usr/src/app/

# We use --no-cache-dir to disable the cache.
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python","app.py"]
