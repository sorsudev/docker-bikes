FROM node:10.16.0-alpine


RUN mkdir /backend
RUN npm config set unsafe-perm true
RUN npm config set prefix /usr/local

WORKDIR /backend
RUN mkdir /root/.ssh
COPY id_rsa /root/.ssh/id_rsa
RUN chmod go-w /root && chmod 700 /root/.ssh && chmod 600 /root/.ssh/id_rsa
RUN apk add --no-cache git openssh-client python g++ make && rm -rf /var/cache/apk/* && ssh-keyscan github.com > ~/.ssh/known_hosts
RUN git clone git@github.com:ricardoaj20003/bikes.git ./
RUN git checkout develop && git reset --hard

RUN npm install pm2 ts-node knex -g

COPY index.js /backend/api_code/run_migrations.js
RUN cd api_code && npm install && npm audit fix --force && pm2 start index.js

RUN npm install
RUN npm audit fix --force
EXPOSE 3003

COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
