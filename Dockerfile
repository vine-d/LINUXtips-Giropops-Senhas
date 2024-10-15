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

HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD ["python", "-c", "import http.client; import sys; conn = http.client.HTTPConnection('localhost', 5000); conn.request('GET', '/'); res = conn.getresponse(); sys.exit(1) if res.status != 200 else sys.exit(0)"]

EXPOSE 5000
ENTRYPOINT ["flask"]
CMD ["run", "--host=0.0.0.0"]
