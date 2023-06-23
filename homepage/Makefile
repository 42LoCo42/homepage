build:
	mkdir -p out
	./processStuff.sh
	homepage-builder
	rsync -av static/ out/
	mkdir -p out/foo

clean:
	rm -rf out tree.html
