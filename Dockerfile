FROM alpine:3.2

RUN apk --update \
    add curl sudo

RUN adduser -g '' -D  z z && \
    echo 'z ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Cache some packages
RUN apk add \
    git \
    zsh \
    tmux \
    vim \
    wget curl \
    jq \
    iftop htop \
    tree \
    unzip

USER z
WORKDIR /home/z

CMD ["zsh"]
