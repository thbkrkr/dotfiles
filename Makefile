ORG 		= krkr
NAME 		= dotfiles
VERSION = $(shell git rev-parse --short HEAD)

all: build

build:
	docker build --rm -t $(ORG)/$(NAME):$(VERSION) .
	docker tag -f $(ORG)/$(NAME):${VERSION} $(ORG)/$(NAME):latest

test: build
	docker run --rm \
		-v $$(pwd):/home/z/.dotfiles \
		-ti $(ORG)/$(NAME) /home/z/.dotfiles/install.sh
