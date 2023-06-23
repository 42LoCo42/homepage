build:
	mkdir -p out
	./processStuff.sh
	homepage-builder
	rsync -av static/ out/

clean:
	rm -rf out tree.html
