#############################################################
#  Gate-All-Around JFET — SDevice Deck
#############################################################

File {
  Grid   = "sdemodel_msh.tdr"
  Plot   = "n1_des.tdr"
  Current = "n1_des.plt"
  Output  = "n1_des.log"
}

#############################################################
# ELECTRODES  (names MUST MATCH SDE)
#############################################################

Electrode {
  { Name="source" Voltage=0.0 }
  { Name="drain"  Voltage=0.0 }
  { Name="gate"   Voltage=-2.0 }
}

#############################################################
# PHYSICS MODELS
#############################################################

Physics {
  Mobility (
    DopingDependence
    HighFieldSat
    Enormal
  )
  EffectiveIntrinsicDensity (BandGapNarrowing (OldSlotboom))
}

#############################################################
# PLOT VARIABLES
#############################################################

Plot {
  eDensity hDensity
  eCurrentDensity hCurrentDensity
  ElectrostaticPotential
  SpaceCharge ElectricField
  eMobility hMobility
  eVelocity hVelocity
  Doping DonorConcentration AcceptorConcentration
}

#############################################################
# NUMERICAL OPTIONS
#############################################################

Math {
  Extrapolate
  RelErrControl
}

#############################################################
# SOLVE SEQUENCE
#############################################################

Solve {

  # -- Initial equilibrium --
  Poisson
  Coupled { Poisson Electron }

  # -- Sweep Vds up to 25 V --
  Quasistationary (
      MaxStep = 0.001
      Goal { Name="drain" Voltage = 25 }
  ) {
      Coupled { Poisson Electron }
  }
}

#############################################################
# END OF FILE
#############################################################

