$PARAM @annotated
CL   :  1 : Clearance (volume/time)
V2   : 20 : Central volume (volume)
Q    :  2 : Inter-compartmental clearance (volume/time)
V3   : 10 : Peripheral volume of distribution (volume)
KA   :  1 : Absorption rate constant (1/time)
ALAG1 : 0 : Lag time for depot compartment
ALAG2 : 0 : Lag time for central compartment

$CMT @annotated
EV     : Extravascular compartment (mass)
CENT   : Central compartment (mass)
PERIPH : Peripheral compartment (mass) 

$GLOBAL
#define CP (CENT/V2)

$MAIN
ALAG_EV = ALAG1;
ALAG_CENT = ALAG2;

$PKMODEL ncmt = 2, depot = TRUE

$TABLE
double CPERIPH = PERIPH/V3;

$CAPTURE @annotated
CP : Plasma concentration (mass/time)
CPERIPH : Peripheral concentration (mass/time)  
