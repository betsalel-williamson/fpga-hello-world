all: test

build:
	iverilog -o hello_world.vvp hello_world.v

simulate:
	vvp hello_world.vvp

verify:
	./verify_simulation.sh

test: build simulate verify

clean:
	rm -f *.vvp *.vcd
