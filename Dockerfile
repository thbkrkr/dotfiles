FROM debian:jessie

RUN apt-get update && \
    apt-get install -y curl sudo

RUN adduser --disabled-password --gecos '' z && \
    adduser z sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Cache some packages
RUN apt-get install -y \
    git \
    zsh \
    tmux \
    vim \
    iftop htop \
    unzip \
    tree \
    dos2unix \
    wget curl \
    jq \
    build-essential

USER z
WORKDIR /home/z

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh 

CMD ["zsh"]
