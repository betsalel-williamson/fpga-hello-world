all: build

build:
	iverilog -o hello_world.vvp hello_world.v

simulate:
	vvp hello_world.vvp

clean:
	rm -f *.vvp *.vcd
