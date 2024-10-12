FROM cgr.dev/chainguard/python:latest-dev AS build

WORKDIR /app

RUN python -m venv venv
ENV PATH="/app/venv/bin:$PATH"
COPY giropops-senhas/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# ignore warnings DL3007: bcs chainguard only offers the `latest` tag for free.
# hadolint ignore=DL3007
FROM cgr.dev/chainguard/python:latest

WORKDIR /app

COPY --from=build /app/venv /app/venv
COPY giropops-senhas/ ./

ENV REDIS_HOST=redis PATH="/app/venv/bin:$PATH"
EXPOSE 5000
ENTRYPOINT ["flask"]
CMD ["run", "--host=0.0.0.0"]
