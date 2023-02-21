COMMON_DIR ?= common
TOP 	  = compteur4
#Liste des TOP autorisés
TOP_OK	  = compteur4 compteurgene lecture_memoire VGA

include $(COMMON_DIR)/TPenv.mk

ifdef IMG
img.mem: $(IMG) force
	convert $< -resize 320x240 -extent 320x240 -depth 6 -colorspace RGB -compress none ppm:- | \
	awk 'BEGIN {v=0;n0=32;n=n0; printf "@0 "} NR>3 {for (i=1;i<=NF;i+=3) {n-=8 ; v+=lshift(rshift($$i,6),n+6)+lshift(rshift($$(i+1),5),n+3)+lshift(rshift($$(i+2),5),n) ; if (n==0) { printf "%08x\n", v;v=0;n=n0} }} ' > $@
force:
endif

include $(COMMON_DIR)/TPrules.mk
