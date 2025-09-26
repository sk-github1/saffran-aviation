FROM python:3.11-slim
WORKDIR /app
COPY app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt
COPY app/ /app/
EXPOSE 8080
CMD [ "gunicorn", "--bind", "0.0.0.0:8080", "app:app", "--workers", "3" ]
