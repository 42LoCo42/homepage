build:
	mkdir -p out
	tar xf $(ELEMENT) -C out --strip-components 1
	rsync -av static/ out/

clean:
	rm -rf out
