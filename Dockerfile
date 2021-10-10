FROM ubuntu:20.04
ENV NODE_VERSION=12.6.0
RUN sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get install -y curl openjdk-13-jdk ruby tzdata tar bash ttf-dejavu  fontconfig wget  
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
#RUN apt update && apt upgrade && apk --update add \
#    ruby build-base libstdc++ tzdata bash ttf-dejavu freetype fontconfig wget curl

RUN wget http://cdn.sencha.com/cmd/7.4.0.39/no-jre/SenchaCmd-7.4.0.39-linux-amd64.sh.zip -O senchacmd.zip && unzip senchacmd.zip && rm senchacmd.zip && chmod +x SenchaCmd-7.4.0.39-linux-amd64.sh
RUN ./SenchaCmd-7.4.0.39-linux-amd64.sh -q -dir /opt/Sencha/Cmd/7.4.0.39 -Dall=true
RUN rm SenchaCmd-7.4.0.39-linux-amd64.sh && chmod +x /opt/Sencha/Cmd/7.4.0.39/sencha
COPY appcode /appcode
ENV PJS_HOME=/usr/lib/phantomjs
WORKDIR /appcode
RUN export PATH="$PATH:/opt/Sencha/Cmd/7.4.0.39/sencha"
EXPOSE 1841
CMD [ "/opt/Sencha/Cmd/7.4.0.39/sencha", "app", "watch" ]
