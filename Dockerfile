FROM ubuntu:20.04

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN apt-get -qq update && \
    apt-get upgrade -y && apt-get autoremove -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get -qq install -y tzdata aria2 wget git python3 python3-pip \
    locales python3-lxml \
    curl pv jq ffmpeg \
    p7zip-full mediainfo p7zip-rar \
    libcrypto++-dev libssl-dev \
    libc-ares-dev libcurl4-openssl-dev \
    libsqlite3-dev libsodium-dev && \
    curl -L https://github.com/viswanathbalusu/megasdkrest/releases/download/v0.1.1/megasdkrest -o /usr/local/bin/megasdkrest && \
    chmod +x /usr/local/bin/megasdkrest

COPY requirements.txt .
COPY extract /usr/local/bin
COPY pextract /usr/local/bin
RUN chmod +x /usr/local/bin/extract && chmod +x /usr/local/bin/pextract
RUN wget -q https://github.com/P3TERX/aria2.conf/raw/master/dht.dat -O /usr/src/app/dht.dat && \
wget -q https://github.com/P3TERX/aria2.conf/raw/master/dht6.dat -O /usr/src/app/dht6.dat
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
COPY netrc /root/.netrc
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \ 
locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

CMD ["bash","start.sh"]