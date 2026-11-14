import tskmadules

Dockerfile = """
FROM python:3.11-slim
WORKDIR /runtsk
COPY . .
EXPOSE 80
CMD [ "python", "-m", "http.server", "80" ]
"""

check_change = tskmadules.readDockerfile()
if tskmadules.exists('Dockerfile'):
    if Dockerfile != check_change:
        print("sudo docker compose up --build -d")
    else:
        print("sudo docker compose up -d")
