all: test

build:
	verilator --binary -j 0 -Wall hello_world.sv

simulate:
	./obj_dir/Vhello_world

verify:
	./verify_simulation.sh

test: build simulate verify

clean:
	rm -rf obj_dir