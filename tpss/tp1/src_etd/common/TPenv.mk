ifndef TOP_ENTITY
	TOP_ENTITY = $(TOP)
endif

FPGA	  = xc7z010-clg400-1

SIMU_WDB  = $(TB_ENTITY)_isim_beh.wdb

REPORTS = $(filter %.rpt, $(wildcard *))

TOCLEAN = $(filter %log %.jou \
                   %.mmi \
                   $(addsuffix .prj,$(TOP_OK)) %.wdb xvhdl% xelab% xsim% vivado% updatemem% usage_statistics_webtalk%,$(wildcard *))

TOCLEAN += $(REPORTS)

TOPOLISH = $(TOCLEAN) download.bit $(wildcard _*) $(wildcard *.dcp) .Xil $(wildcard /tmp/*.xilwvdat)


VERB     := 0
q         = $(if $(filter 1, $(VERB)),$1,\
				$(if $(2),@echo $2 && $1 > $3 2>&1, @$1))

ifdef MEM_FILE
	TARGET:=golden.bit
	MMI_FILE:=$(TOP).mmi
else
	TARGET:=download.bit
endif

# Verification que l'environement de Xilinx Vivado a bien été sourcé
ifeq ($(origin XILINX_VIVADO), undefined)
  $(error "Outils Xilinx introuvables, lancez d'abord la commande: source /bigsoft/Xilinx/Vivado/2019.1/settings64.sh")
endif
XILINX_PREFIX := $(XILINX_VIVADO)/bin/

# Verification que le TOP est autorisé
ifeq ($(filter $(TOP),$(TOP_OK)),)
  $(error Toplevel $(TOP) inconnu)
endif

# Les Toplevels du TP
  TOP_REEL	:= $(TOP)
  TB_ENTITY	:= tb_$(TOP_ENTITY)
  PRJ  		:= tb_$(TOP).prj


VHD_TB := $(shell sed -e 's/vhdl work "\(.*\)"/\1 /' $(PRJ))
VHD_SRC := $(shell grep -i -v -- "$(TB_ENTITY)" $(PRJ) > $(TOP).prj ; sed -e 's/vhdl work "\(.*\)"/\1 /' $(TOP).prj)
