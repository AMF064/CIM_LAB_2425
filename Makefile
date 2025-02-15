ANL := ghdl -a # analyze
ELA := ghdl -e # elaborate
TARGETS := GenSen temporizador
SRC := ${TARGETS:%=%.vhd}

.PHONY: all ${TARGETS} clean
all: ${TARGETS}

GenSen: GenSen.vhd
	${ANL} $<
	${ELA} $@

temporizador: temporizador.vhd
	${ANL} $<
	${ELA} $@

clean:
	shred -u work-obj93.cf
