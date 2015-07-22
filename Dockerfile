FROM index.alauda.cn/alauda/ubuntu

MAINTAINER Komey <lmh5257@live.cn>

ADD . /home/docker/code/ 

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server pwgen build-essential git python python-dev python-setuptools nginx sqlite3 supervisor

RUN easy_install pip && pip install uwsgi

RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

RUN echo "daemon off;" >> /etc/nginx/nginx.conf && rm /etc/nginx/sites-enabled/default && ln -s /home/docker/code/nginx-app.conf /etc/nginx/sites-enabled/ && ln -s /home/docker/code/supervisor-app.conf /etc/supervisor/conf.d/

RUN pip install -r /home/docker/code/app/requirements.txt && chmod +x /home/docker/code/*.sh

VOLUME ["/home/docker/code/app"]
EXPOSE 22 
EXPOSE 80
CMD ["/home/docker/code/run.sh"]
