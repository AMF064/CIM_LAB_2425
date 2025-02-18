ANL := ghdl -a # analyze
ELA := ghdl -e # elaborate
RUN := ghdl -r # run
TARGETS := GenSen rom GenSen_tb
SRC := ${TARGETS:%=%.vhd}

.PHONY: all ${TARGETS} clean test
all: ${TARGETS}

GenSen: GenSen.vhd rom
	${ANL} $<
	${ELA} $@

rom: rom.vhd
	${ANL} $<
	${ELA} $@

GenSen_tb: GenSen_tb.vhd GenSen rom
	${ANL} $<
	${ELA} $@

test: GenSen_tb
	${RUN} $<

clean:
	shred -u work-obj93.cf
