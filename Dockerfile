FROM python:alpine3.20

WORKDIR /app

COPY giropops-senhas/ .

RUN \
  apk update && \
  pip install --no-cache-dir -r requirements.txt

ENV REDIS_HOST=redis

EXPOSE 5000

ENTRYPOINT ["flask"]
CMD ["run", "--host=0.0.0.0"]
