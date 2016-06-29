all: build

build:
	@docker build --tag=hrektts/fusiondirectory:latest .

release: build
	@docker build --tag=hrektts/fusiondirectory:$(shell cat VERSION) .

.PHONY: test
test:
	@docker build -t hrektts/fusiondirectory:bats .
	bats test
