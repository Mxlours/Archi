COMMON_DIR ?= common
TOP 	  = PO
#Liste des TOP autorisés
TOP_OK	  = PO PGCD PGCDFPGA

include $(COMMON_DIR)/TPenv.mk

# Ajustement au cas par cas
ifeq ($(TOP), PO)
  ENABLE_PROG 	:= 0
endif
ifeq ($(TOP), PGCD)
  ENABLE_PROG 	:= 0
endif

include $(COMMON_DIR)/TPrules.mk
