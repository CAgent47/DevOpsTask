import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

Dockerfile = """
FROM python:3.13.14-trixie
WORKDIR /runtsk
COPY . .
EXPOSE 80
CMD [ "python", "-m", "http.server", "80" ]
"""

Build_file = BASE_DIR / "Dockerfile"

def readDockerfile():
    with open(Build_file, 'r') as CDFile:
        return CDFile.read()

def createDockerfile():
    if not Build_file.exists():
        Build_file.write_text(Dockerfile)
    else:
        print("[ Python ]: Done!")

def exists(file):
    return os.path.exists(file)
