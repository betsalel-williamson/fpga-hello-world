VHDL_SOURCES = hello_world.vhdl
TOP_ENTITY = hello_world
SIM_OUT = $(TOP_ENTITY).out

all: test

build:
	ghdl -a $(VHDL_SOURCES)
	ghdl -e $(TOP_ENTITY)

simulate:
	ghdl -r $(TOP_ENTITY)

verify:
	./verify_simulation.sh

test: build verify

clean:
	rm -f *.o *.cf $(SIM_OUT) $(TOP_ENTITY) *.fst

.PHONY: all compile simulate clean
