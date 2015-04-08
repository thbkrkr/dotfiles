ORG = krkr
NAME = dotfiles
VERSION = $(shell git log --pretty=oneline -1 | cut -c-10)

all: build

build:
	docker build --rm -t $(ORG)/$(NAME):$(VERSION) .
	docker tag -f $(ORG)/$(NAME):${VERSION} $(ORG)/$(NAME):latest

test:
	docker run \
		-v $(shell pwd):/home/z/.dotfiles \
		-ti $(ORG)/$(NAME) bash
