ARG BASE_IMAGE=pytorch/pytorch:1.13.0-cuda11.6-cudnn8-devel

FROM ${BASE_IMAGE} as dev-base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND noninteractive\
    SHELL=/bin/bash
RUN apt-get update --yes && \
    # - apt-get upgrade is run to patch known vulnerabilities in apt-get packages as
    #   the ubuntu base image is rebuilt too seldom sometimes (less than once a month)
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends\
    git\
    wget\
    curl\
    git\
    bash\
    awscli\
    openssh-server &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN jupyter nbextension enable --py widgetsnbextension
ENV AWS_CONFIG_FILE=/workspace/.aws/config
ENV AWS_SHARED_CREDENTIALS_FILE=/workspace/.aws/credentials

ADD start.sh /

RUN chmod +x /start.sh

CMD [ "/start.sh" ]