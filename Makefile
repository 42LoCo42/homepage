TARGETS := \
	homepage \
	element \

build:
	./run.sh build $(TARGETS)

clean:
	./run.sh clean $(TARGETS)

image:
	docker build -t my-caddy .
