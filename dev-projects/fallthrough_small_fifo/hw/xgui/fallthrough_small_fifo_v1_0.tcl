# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
	set Page0 [ipgui::add_page $IPINST -name "Page 0" -layout vertical]
	set Component_Name [ipgui::add_param $IPINST -parent $Page0 -name Component_Name]
	set MAX_DEPTH_BITS [ipgui::add_param $IPINST -parent $Page0 -name MAX_DEPTH_BITS]
	set WIDTH [ipgui::add_param $IPINST -parent $Page0 -name WIDTH]
	set PROG_FULL_THRESHOLD [ipgui::add_param $IPINST -parent $Page0 -name PROG_FULL_THRESHOLD]
}

proc update_PARAM_VALUE.MAX_DEPTH_BITS { PARAM_VALUE.MAX_DEPTH_BITS } {
	# Procedure called to update MAX_DEPTH_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_DEPTH_BITS { PARAM_VALUE.MAX_DEPTH_BITS } {
	# Procedure called to validate MAX_DEPTH_BITS
	return true
}

proc update_PARAM_VALUE.WIDTH { PARAM_VALUE.WIDTH } {
	# Procedure called to update WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH { PARAM_VALUE.WIDTH } {
	# Procedure called to validate WIDTH
	return true
}

proc update_PARAM_VALUE.PROG_FULL_THRESHOLD { PARAM_VALUE.PROG_FULL_THRESHOLD } {
	# Procedure called to update PROG_FULL_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PROG_FULL_THRESHOLD { PARAM_VALUE.PROG_FULL_THRESHOLD } {
	# Procedure called to validate PROG_FULL_THRESHOLD
	return true
}


proc update_MODELPARAM_VALUE.WIDTH { MODELPARAM_VALUE.WIDTH PARAM_VALUE.WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH}] ${MODELPARAM_VALUE.WIDTH}
}

proc update_MODELPARAM_VALUE.MAX_DEPTH_BITS { MODELPARAM_VALUE.MAX_DEPTH_BITS PARAM_VALUE.MAX_DEPTH_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_DEPTH_BITS}] ${MODELPARAM_VALUE.MAX_DEPTH_BITS}
}

proc update_MODELPARAM_VALUE.PROG_FULL_THRESHOLD { MODELPARAM_VALUE.PROG_FULL_THRESHOLD PARAM_VALUE.PROG_FULL_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PROG_FULL_THRESHOLD}] ${MODELPARAM_VALUE.PROG_FULL_THRESHOLD}
}

