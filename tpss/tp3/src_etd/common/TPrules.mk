all: analyse

.PHONY: analyse elaboration synthese synthese run_fpga clean realclean cleanreports

## Regles de simulation

analyse: $(VHD_TB)
	@echo "  Analyse"
	@$(XILINX_PREFIX)xvhdl -prj $(PRJ) -nolog | tee $@.log | grep -E "ERROR" ; exit $$(( ! $$? ))

elaboration: analyse
	$(call q,\
	    $(XILINX_PREFIX)xelab work.$(TB_ENTITY) -nolog -debug typical -cc gcc\
	    , "  Elaboration",$@.log)

run_simu: elaboration $(MEM_FILE)
	$(call q,\
	    $(XILINX_PREFIX)xsim work.$(TB_ENTITY) -nolog -gui -wdb $(SIMU_WDB) $(MAGIC_VIEW) -tclbatch $(COMMON_DIR)/run.tcl\
	    , "  Simulation",$@.log)


## Regles de synthese

ifdef MEM_FILE
ENABLE_MEM := 1
download.bit: $(TARGET) $(MEM_FILE) $(MMI_FILE)
	$(call q, $(XILINX_PREFIX)updatemem -debug -force --meminfo $(MMI_FILE) --data $(MEM_FILE) --proc $(MEM_ID) --bit $< --out $@\
	    , "  MAJ du fichier de configuration", $@.mem.log)
else
ENABLE_MEM := 0
endif


synthese: $(TOP)_utilization.rpt $(TOP)_timing.rpt $(TOP)_summary.rpt 
	@echo "Rapport d'utilisation disponible dans $(TOP)_utilization.rpt"
	@echo "Rapport de timing disponible dans $(TOP)_timing.rpt"
	@python3 $(COMMON_DIR)/parse_report.py $^

$(TOP)_utilization.rpt $(TOP)_timing.rpt $(TOP)_summary.rpt: $(COMMON_DIR)/synthese.vivado.tcl $(MEM_FILE) $(VHD_SRC)
	$(call q, \
	    $(XILINX_PREFIX)vivado -nolog -nojournal -mode batch -source $< -tclargs $(FPGA) $(TOP_REEL) $(TOP_ENTITY)\
	    , "  Synthese",$@.log)


$(TARGET): $(COMMON_DIR)/bitstream.vivado.tcl $(VHD_SRC) $(TOP)_$(FPGA).xdc
	$(call q, \
	    $(XILINX_PREFIX)vivado -nolog -nojournal -mode batch -source $< -tclargs $(FPGA) $(TOP_REEL) $@ $(ENABLE_MEM) \
	    , "  Génération du bitstream",$@.log)

run_fpga: download.bit $(COMMON_DIR)/programFPGA.vivado.tcl
	$(call q, \
	    $(XILINX_PREFIX)vivado -nolog -nojournal -mode batch -source $(COMMON_DIR)/programFPGA.vivado.tcl -nolog -nojournal \
	                           -tclargs $(FPGA) $(TOP_REEL) $< \
	    , "  Programmation",prog.log )

$(TOP)_$(FPGA).xdc:
	$(error Programmation non prévue pour le toplevel $(TOP_REEL))

cleanreports:
	$(call q, rm -rf $(REPORTS),)

clean: 
	$(call q, rm -rf $(TOCLEAN),)

realclean: clean cleanreports 
	$(call q, rm -rf $(TOPOLISH),)
