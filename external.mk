# You can define common targets or hooks here
$(eval $(call BR2_EXTERNAL_BOARD_DEF,licheepi_zero))
include $(sort $(wildcard $(BR2_EXTERNAL)/package/*/*.mk))
