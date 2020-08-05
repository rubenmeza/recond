FROM ubuntu:18.04

LABEL \
    name="Recon" \
    autor="Ruben Meza <rmezar@gmail.com>" \
    maintainer="Ruben Meza" \
    description="Recon is a automated application of recon process, useful for information gathering"

ENV HOME /root

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir ${HOME}/toolkit && \
    mkdir ${HOME}/wordlists && \
    mkdir ${HOME}/wordlists/ctf

# Install Essentials
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    git \
    wget \
    curl \
    make \
    nmap \
    python \
    python-pip \
    python3 \
    python3-pip \
    dnsrecon

# go
RUN cd /opt && \
    wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz && \
    tar -xvf go1.14.4.linux-amd64.tar.gz && \
    rm -rf /opt/go1.14.4.linux-amd64.tar.gz && \
    mv go /usr/local
ENV GOROOT /usr/local/go
ENV GOPATH /root/go
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:${PATH}

# sublist3r
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/aboul3la/Sublist3r.git && \
    cd Sublist3r/ && \
    pip install -r requirements.txt && \
    ln -s ${HOME}/toolkit/Sublist3r/sublist3r.py /usr/local/bin/sublist3r

# FFUF
RUN go get github.com/ffuf/ffuf && \
    ln -s ${HOME}/go/bin/ffuf /usr/sbin/ffuf

# amass
RUN export GO111MODULE=on && \
    go get github.com/OWASP/Amass/v3/...

# wordlists
RUN cd ${HOME}/wordlists/ctf && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-100.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-10000.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/namelist.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt