all: build

build:
	@docker build -t hrektts/fusiondirectory:latest .

release: build
	@docker build -t hrektts/fusiondirectory:$(shell cat Dockerfile | \
		grep version | \
		sed -e 's/[^"]*"\([^"]*\)".*/\1/') .

.PHONY: test
test:
	@docker build -t hrektts/fusiondirectory:bats .
	bats test
