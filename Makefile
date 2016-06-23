all: build

build:
	@docker build --tag=hrektts/fusiondirectory:latest .

release: build
	@docker build --tag=hrektts/fusiondirectory:$(shell cat VERSION) .
