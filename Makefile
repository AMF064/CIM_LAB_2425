ANL := ghdl -a --std=08 # analyze
ELA := ghdl -e --std=08 # elaborate
RUN := ghdl -r --std=08 # run
TARGETS := GenSen rom GenSen_tb FIR
SRC := ${TARGETS:%=%.vhd}
TEST_WAVEFORM_FILE := test_out.vcd

.PHONY: all ${TARGETS} clean test
all: ${TARGETS}

GenSen: GenSen.vhd rom FIR
	${ANL} $<
	${ELA} $@

rom: rom.vhd
	${ANL} $<
	${ELA} $@

FIR: FIR.vhd
	${ANL} $<
	${ELA} $@

GenSen_tb: GenSen_tb.vhd GenSen rom FIR
	${ANL} $<
	${ELA} $@

test: GenSen_tb
	${RUN} $< --vcd=${TEST_WAVEFORM_FILE}

clean:
	shred -u work-obj[0-9][0-9].cf
