FROM ghcr.io/linuxserver/calibre

RUN apt update
RUN apt install nodejs npm -y
RUN npm install -g n
RUN n stable
RUN apt-get install libxss1 libappindicator1 libindicator7 -y
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install ./google-chrome*.deb -y
RUN rm ./google-chrome*.deb
COPY ./src/ /k8s-docs/
WORKDIR /k8s-docs/
RUN npm install puppeteer --save

ENTRYPOINT [ "/k8s-ebooks/entry_point.sh" ]