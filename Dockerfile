# syntax=docker/dockerfile:1
FROM nvcr.io/nvidia/pytorch:24.01-py3

# Instalacja potrzebnego narzędzia do pobierania plików, np. wget
RUN apt-get update && apt-get install -y --no-install-recommends wget \
    && rm -rf /var/lib/apt/lists/*

# Pobieranie i instalacja lava-nc
RUN wget https://github.com/lava-nc/lava/releases/download/v0.9.0/lava_nc-0.9.0.tar.gz \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir lava_nc-0.9.0.tar.gz

# Instalacja dodatkowych pakietów
RUN pip install --no-cache-dir neurobench snntorch

RUN apt update && apt install pipx && pipx ensurepath

RUN pipx install poetry

RUN cd $HOME && git clone https://github.com/lava-nc/lava-dl.git && cd lava-dl/

RUN poetry config virtualenvs.in-project true && poetry install

RUN source .venv/bin/activate

RUN pytest