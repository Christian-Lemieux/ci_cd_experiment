PWD=$(shell pwd)
SERVICE_NAME=$(shell basename $(PWD))
TIME_STAMP:=$(shell date -u +"%Y%m%dT%H%M%SZ")
VERSION=$(TIME_STAMP)-$(shell git describe --tags --always --dirty)
SERVICE_PORT=2193
CONTAINER_ID=.container.id
LAST_TAG=.last_tag

build:
	@echo -n "$(SERVICE_NAME):$(VERSION)" > $(LAST_TAG)
	$(RM) bin/$(SERVICE_NAME)
	docker build -t $(SERVICE_NAME):$(VERSION) .

run: prune build stop
	docker run -v $(PWD)/app:/app/app:ro -d -p $(SERVICE_PORT):$(SERVICE_PORT) --name $(SERVICE_NAME) $(SERVICE_NAME):$(VERSION) > $(CONTAINER_ID)

prune:
	docker image prune -a -f --filter 'label=service=$(SERVICE_NAME)'

stop:
	-cat $(CONTAINER_ID)  | xargs -I xxx docker kill xxx
	-cat $(CONTAINER_ID)  | xargs -I xxx docker rm xxx
	-$(RM) $(CONTAINER_ID)

clean:
	$(RM) $(SERVICE_NAME)
	$(RM) -r bin
	docker ps -af status=exited | grep $(SERVICE_NAME) | awk '{print $$1}' | xargs -I xxx docker rm xxx
	docker images -qf dangling=true | grep $(SERVICE_NAME) | awk '{print $$3}' | xargs -I xxx docker rmi xxx

tail:
	-cat $(CONTAINER_ID)  | xargs -I xxx docker logs --follow xxx