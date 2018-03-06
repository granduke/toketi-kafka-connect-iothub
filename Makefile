.PHONY: test
test:
	mvn -T 4 test

.PHONY: build
build:
	mvn -T 4 clean package

build-docker:
	docker build -t ${IMAGE} .

push-docker:
	docker push ${IMAGE}

clean:
	rm -rf target

