FROM ubuntu:18.04
RUN apt update && \
    apt install curl git ansible -y
RUN curl -L https://github.com/stelligent/config-lint/releases/latest/download/config-lint_Linux_x86_64.tar.gz | tar xz -C /usr/local/bin config-lint && \
    chmod +rx /usr/local/bin/config-lint
RUN mkdir /root/Code
COPY tfrun.sh /root/Code
WORKDIR /root/Code
COPY akey.pem /root/Code
RUN chmod 755 tfrun.sh && \
    ./tfrun.sh
CMD ["/bin/bash", "-D"]
