# Giropops-senhas Python App Containerization Solution

As part of the program PICK2024/2 at LINUXTips, I created a Docker image for the Giropops-senhas Python app with a focus on performance and security.

---

## Key Considerations

- Minimizing image size through secure and lightweight Chainguard images
  - Reduces vulnerabilities and attack surface
  - Eliminates unnecessary packages
- Scanning for known vulnerabilities using `docker scout` (or Trivy)
- Publishing the image to Docker Hub with integrity verification via Cosign

## Results

- Final image compressed size **28.83 MB**
- **Zero** know vulnerabilities

---

## Requirements to play

- Docker - https://docs.docker.com/get-started/get-docker
- Cosign - https://github.com/sigstore/cosign
- (_optional_) - Trivy https://github.com/aquasecurity/trivy

## To test

- Pull the signed image from DockerHub:
  `docker pull vined/linuxtips-giropops-senhas:2.0`

- Now you can now verify the integrity of the image using [**cosign**](https://github.com/sigstore/cosign) from sigstore:
  `cosign verify --key cosign-vined.pub vined/linuxtips-giropops-senhas:2.0`

  Expected output similar to:

```
Verification for index.docker.io/vined/linuxtips-giropops-senhas:2.0 --
The following checks were performed on each of these signatures:
  - The cosign claims were validated
  - Existence of the claims in the transparency log was verified offline
  - The signatures were verified against the specified public key

[{"critical":{"identity":{"docker-reference":"index.docker.io/vined/linuxtips-giropops-senhas"},
"image":{"docker-manifest-digest":"sha256:fa34ebf108a9e2effc779d8d88e92e2230c54d79ed397ee98a650a5c111bd7de"},
"type":"cosign container image signature"},
"optional":{"Bundle":{"SignedEntryTimestamp":"MEUCIQD9vgsZC/tzZQhAkWQzcD9ylY8FW7izHLGJWaHX0S2cSwIgM8M8H...",
"Payload":{"body":"eyJhcGlWZXJzaW9uIjXRhIjp7ImhhIidGVudCI6Ik1FVUNJR0oxNnY2bzYxTi9uQk1ORUNNUGFXcVRLY3B...}}}}]
```

- To scan for the known vulnerabilities present in the image:
  `docker scout cves vined/linuxtips-giropops-senhas:2.0` - _in the day it was published it has zero know vulnerabilities._
- (_optional_) - using Trivy:
  `trivy image vined/linuxtips-giropops-senhas:2.0`

### Running the app

- It's required a **redis** server to be acessible and its hostname to be set in the env _REDIS_HOST_ of the app container.

  - One simple way to make it work quickly for test purpouses is attaching the containers(app and redis) to a same network:

    - `docker network create <tmp-name>`
    - `docker container run -d --name redis -p 6379:6379 --network <tmp-net> redis`
    - `docker container run -d --name giropops-senhas -p 5000:5000 --network <tmp-net> vined/linuxtips-giropops-senhas:2.0`

    \* Doing that, the app _giropops-senhas_ will be acle to reach the redis by the container name as the default value of _REDIS_HOST_ is **redis**.

- If everything runs well you should by now, be able to access the giropops-senhas app: http://localhost:5000
  .
