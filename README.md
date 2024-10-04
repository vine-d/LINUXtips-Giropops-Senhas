# Giropops-senhas Python App Containerization Solution

As part of the program PICK2024/2 at LINUXTips, I created a Docker image for the Giropops-senhas Python app with a focus on performance and security.

---

## Key Considerations

- Minimizing image size through secure and lightweight Chainguard images
  - Reduces vulnerabilities and attack surface
  - Eliminates unnecessary packages
- Scanning for known vulnerabilities using `docker scout` (or Thrivy)
- Publishing the image to Docker Hub with integrity verification via Cosign
