File {
* input files:
Grid = "sdemodel_msh.tdr"
* output files:
Plot = "n1_des.tdr"
Current = "n1_des.plt"
Output = "n1_des.log"
}
Electrode {
{ Name="source" Voltage=0.0 }
{ Name="drain" Voltage= 3}
{ Name="gate" Voltage= -2 }
}
Physics {
Mobility (DopingDependence HighFieldSat Enormal)
EffectiveIntrinsicDensity (BandGapNarrowing (OldSlotboom))
}
Plot {
eDensity hDensity eCurrent hCurrent
Potential SpaceCharge ElectricField
eMobility hMobility eVelocity hVelocity
Doping DonorConcentration AcceptorConcentration
}
Math {
Extrapolate
RelErrControl
}
Solve {
#-initial solution:
Poisson
Coupled { Poisson Electron }
#-ramp gate:
Quasistationary ( MaxStep=0.001
Goal{ Name="drain" Voltage= 25} )
{ Coupled { Poisson Electron } }
}
