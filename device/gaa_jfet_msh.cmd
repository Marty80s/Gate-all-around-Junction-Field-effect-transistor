Title ""

Controls {
}

IOControls {
	EnableSections
}

Definitions {
	Constant "ND_Channel" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+18
	}
	Constant "ND_Source" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+19
	}
	Constant "ND_Drain" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+19
	}
	Constant "NA_Gate" {
		Species = "BoronActiveConcentration"
		Value = 1e+19
	}
}

Placements {
	Constant "Dope_Channel" {
		Reference = "ND_Channel"
		EvaluateWindow {
			Element = region ["Channel"]
		}
	}
	Constant "Dope_Source" {
		Reference = "ND_Source"
		EvaluateWindow {
			Element = region ["Source"]
		}
	}
	Constant "Dope_Drain" {
		Reference = "ND_Drain"
		EvaluateWindow {
			Element = region ["Drain"]
		}
	}
	Constant "Dope_Gate" {
		Reference = "NA_Gate"
		EvaluateWindow {
			Element = region ["Gate"]
		}
	}
}

