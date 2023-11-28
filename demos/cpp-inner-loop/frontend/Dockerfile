FROM python:3.9
RUN mkdir /app
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
COPY . /app
WORKDIR /app
ENTRYPOINT [ "python", "manage.py", "runserver", "0.0.0.0:80" ]
