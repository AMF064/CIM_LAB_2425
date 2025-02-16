ANL := ghdl -a # analyze
ELA := ghdl -e # elaborate
TARGETS := GenSen rom
SRC := ${TARGETS:%=%.vhd}

.PHONY: all ${TARGETS} clean
all: ${TARGETS}

GenSen: GenSen.vhd rom
	${ANL} $<
	${ELA} $@

rom: rom.vhd
	${ANL} $<
	${ELA} $@

clean:
	shred -u work-obj93.cf
