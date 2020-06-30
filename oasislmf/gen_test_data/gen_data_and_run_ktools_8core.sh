#!/bin/bash

SECONDS=0   # start timer

# -------- PART 1: GENERATE DATA --------
# Set up input variables
numVulnerabilities=20
numIntensityBins=40
numDamageBins=12
vulnerabilitySparseness=1.0		# default value 1.0
numEvents=100
numAreaperils=100
areaperilsPerEvent=$numAreaperils	# default value numAreaperils
intensitySparseness=1.0			# default value 1.0
noIntensityUncertainty=false		# default value False
numPeriods=10
numRandoms=0				# default value 0 (no random.bin file)
randomSeed=-1				# default value -1 (random seed 1234)
numLocations=100
coveragesPerLocation=3
numLayers=1				# default value 1

if [ "$noIntensityUncertainty" = true ] ; then
	noIntensityUncertainty="--no-intensity-uncertainty"
else
	noIntensityUncertainty=""
fi

# Generate data
python generate_test_data.py --num-vulnerabilities $numVulnerabilities --num-intensity-bins $numIntensityBins --num-damage-bins $numDamageBins --vulnerability-sparseness $vulnerabilitySparseness --num-events $numEvents --num-areaperils $numAreaperils --areaperils-per-event $areaperilsPerEvent --intensity-sparseness $intensitySparseness --num-periods $numPeriods --num-randoms $numRandoms --random-seed $randomSeed --num-locations $numLocations --coverages-per-location $coveragesPerLocation --num-layers $numLayers $noIntensityUncertainty

echo "Time taken to generate data:"
date +%T -d "1/1 + $SECONDS sec"

# -------- PART 2: RUN KTOOLS --------
# Set up run directories

rm -rf log
mkdir log/

rm -rf work/
mkdir work/
mkdir work/kat
mkdir work/gul_S1_summaryleccalc
mkdir work/gul_S1_summaryaalcalc
mkdir work/il_S1_summaryleccalc
mkdir work/il_S1_summaryaalcalc

rm -rf fifo/
mkdir fifo/

rm -rf output
mkdir output

mkfifo fifo/gul_P1
mkfifo fifo/gul_P2
mkfifo fifo/gul_P3
mkfifo fifo/gul_P4
mkfifo fifo/gul_P5
mkfifo fifo/gul_P6
mkfifo fifo/gul_P7
mkfifo fifo/gul_P8

mkfifo fifo/il_P1
mkfifo fifo/il_P2
mkfifo fifo/il_P3
mkfifo fifo/il_P4
mkfifo fifo/il_P5
mkfifo fifo/il_P6
mkfifo fifo/il_P7
mkfifo fifo/il_P8

mkfifo fifo/gul_S1_summary_P1
mkfifo fifo/gul_S1_summaryeltcalc_P1
mkfifo fifo/gul_S1_eltcalc_P1
mkfifo fifo/gul_S1_summary_P2
mkfifo fifo/gul_S1_summaryeltcalc_P2
mkfifo fifo/gul_S1_eltcalc_P2
mkfifo fifo/gul_S1_summary_P3
mkfifo fifo/gul_S1_summaryeltcalc_P3
mkfifo fifo/gul_S1_eltcalc_P3
mkfifo fifo/gul_S1_summary_P4
mkfifo fifo/gul_S1_summaryeltcalc_P4
mkfifo fifo/gul_S1_eltcalc_P4
mkfifo fifo/gul_S1_summary_P5
mkfifo fifo/gul_S1_summaryeltcalc_P5
mkfifo fifo/gul_S1_eltcalc_P5
mkfifo fifo/gul_S1_summary_P6
mkfifo fifo/gul_S1_summaryeltcalc_P6
mkfifo fifo/gul_S1_eltcalc_P6
mkfifo fifo/gul_S1_summary_P7
mkfifo fifo/gul_S1_summaryeltcalc_P7
mkfifo fifo/gul_S1_eltcalc_P7
mkfifo fifo/gul_S1_summary_P8
mkfifo fifo/gul_S1_summaryeltcalc_P8
mkfifo fifo/gul_S1_eltcalc_P8

mkfifo fifo/il_S1_summary_P1
mkfifo fifo/il_S1_summaryeltcalc_P1
mkfifo fifo/il_S1_eltcalc_P1
mkfifo fifo/il_S1_summary_P2
mkfifo fifo/il_S1_summaryeltcalc_P2
mkfifo fifo/il_S1_eltcalc_P2
mkfifo fifo/il_S1_summary_P3
mkfifo fifo/il_S1_summaryeltcalc_P3
mkfifo fifo/il_S1_eltcalc_P3
mkfifo fifo/il_S1_summary_P4
mkfifo fifo/il_S1_summaryeltcalc_P4
mkfifo fifo/il_S1_eltcalc_P4
mkfifo fifo/il_S1_summary_P5
mkfifo fifo/il_S1_summaryeltcalc_P5
mkfifo fifo/il_S1_eltcalc_P5
mkfifo fifo/il_S1_summary_P6
mkfifo fifo/il_S1_summaryeltcalc_P6
mkfifo fifo/il_S1_eltcalc_P6
mkfifo fifo/il_S1_summary_P7
mkfifo fifo/il_S1_summaryeltcalc_P7
mkfifo fifo/il_S1_eltcalc_P7
mkfifo fifo/il_S1_summary_P8
mkfifo fifo/il_S1_summaryeltcalc_P8
mkfifo fifo/il_S1_eltcalc_P8

# Do insured loss computes

eltcalc < fifo/il_S1_summaryeltcalc_P1 > work/kat/il_S1_eltcalc_P1 & pid1=$!
eltcalc < fifo/il_S1_summaryeltcalc_P2 > work/kat/il_S1_eltcalc_P2 & pid2=$!
eltcalc < fifo/il_S1_summaryeltcalc_P3 > work/kat/il_S1_eltcalc_P3 & pid3=$!
eltcalc < fifo/il_S1_summaryeltcalc_P4 > work/kat/il_S1_eltcalc_P4 & pid4=$!
eltcalc < fifo/il_S1_summaryeltcalc_P5 > work/kat/il_S1_eltcalc_P5 & pid5=$!
eltcalc < fifo/il_S1_summaryeltcalc_P6 > work/kat/il_S1_eltcalc_P6 & pid6=$!
eltcalc < fifo/il_S1_summaryeltcalc_P7 > work/kat/il_S1_eltcalc_P7 & pid7=$!
eltcalc < fifo/il_S1_summaryeltcalc_P8 > work/kat/il_S1_eltcalc_P8 & pid8=$!

tee < fifo/il_S1_summary_P1 fifo/il_S1_summaryeltcalc_P1 work/il_S1_summaryaalcalc/P1.bin work/il_S1_summaryleccalc/P1.bin > /dev/null & pid9=$!
tee < fifo/il_S1_summary_P2 fifo/il_S1_summaryeltcalc_P2 work/il_S1_summaryaalcalc/P2.bin work/il_S1_summaryleccalc/P2.bin > /dev/null & pid10=$!
tee < fifo/il_S1_summary_P3 fifo/il_S1_summaryeltcalc_P3 work/il_S1_summaryaalcalc/P3.bin work/il_S1_summaryleccalc/P3.bin > /dev/null & pid11=$!
tee < fifo/il_S1_summary_P4 fifo/il_S1_summaryeltcalc_P4 work/il_S1_summaryaalcalc/P4.bin work/il_S1_summaryleccalc/P4.bin > /dev/null & pid12=$!
tee < fifo/il_S1_summary_P5 fifo/il_S1_summaryeltcalc_P5 work/il_S1_summaryaalcalc/P5.bin work/il_S1_summaryleccalc/P5.bin > /dev/null & pid13=$!
tee < fifo/il_S1_summary_P6 fifo/il_S1_summaryeltcalc_P6 work/il_S1_summaryaalcalc/P6.bin work/il_S1_summaryleccalc/P6.bin > /dev/null & pid14=$!
tee < fifo/il_S1_summary_P7 fifo/il_S1_summaryeltcalc_P7 work/il_S1_summaryaalcalc/P7.bin work/il_S1_summaryleccalc/P7.bin > /dev/null & pid15=$!
tee < fifo/il_S1_summary_P8 fifo/il_S1_summaryeltcalc_P8 work/il_S1_summaryaalcalc/P8.bin work/il_S1_summaryleccalc/P8.bin > /dev/null & pid16=$!

( summarycalc -f -1 fifo/il_S1_summary_P1 < fifo/il_P1 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/il_S1_summary_P2 < fifo/il_P2 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/il_S1_summary_P3 < fifo/il_P3 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/il_S1_summary_P4 < fifo/il_P4 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/il_S1_summary_P5 < fifo/il_P5 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/il_S1_summary_P6 < fifo/il_P6 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/il_S1_summary_P7 < fifo/il_P7 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/il_S1_summary_P8 < fifo/il_P8 ) 2>> log/stderror.err &

# Do ground up loss computes

eltcalc < fifo/gul_S1_summaryeltcalc_P1 > work/kat/gul_S1_eltcalc_P1 & pid17=$!
eltcalc < fifo/gul_S1_summaryeltcalc_P2 > work/kat/gul_S1_eltcalc_P2 & pid18=$!
eltcalc < fifo/gul_S1_summaryeltcalc_P3 > work/kat/gul_S1_eltcalc_P3 & pid19=$!
eltcalc < fifo/gul_S1_summaryeltcalc_P4 > work/kat/gul_S1_eltcalc_P4 & pid20=$!
eltcalc < fifo/gul_S1_summaryeltcalc_P5 > work/kat/gul_S1_eltcalc_P5 & pid21=$!
eltcalc < fifo/gul_S1_summaryeltcalc_P6 > work/kat/gul_S1_eltcalc_P6 & pid22=$!
eltcalc < fifo/gul_S1_summaryeltcalc_P7 > work/kat/gul_S1_eltcalc_P7 & pid23=$!
eltcalc < fifo/gul_S1_summaryeltcalc_P8 > work/kat/gul_S1_eltcalc_P8 & pid24=$!

tee < fifo/gul_S1_summary_P1 fifo/gul_S1_summaryeltcalc_P1 work/gul_S1_summaryaalcalc/P1.bin work/gul_S1_summaryleccalc/P1.bin > /dev/null & pid25=$!
tee < fifo/gul_S1_summary_P2 fifo/gul_S1_summaryeltcalc_P2 work/gul_S1_summaryaalcalc/P2.bin work/gul_S1_summaryleccalc/P2.bin > /dev/null & pid26=$!
tee < fifo/gul_S1_summary_P3 fifo/gul_S1_summaryeltcalc_P3 work/gul_S1_summaryaalcalc/P3.bin work/gul_S1_summaryleccalc/P3.bin > /dev/null & pid27=$!
tee < fifo/gul_S1_summary_P4 fifo/gul_S1_summaryeltcalc_P4 work/gul_S1_summaryaalcalc/P4.bin work/gul_S1_summaryleccalc/P4.bin > /dev/null & pid28=$!
tee < fifo/gul_S1_summary_P5 fifo/gul_S1_summaryeltcalc_P5 work/gul_S1_summaryaalcalc/P5.bin work/gul_S1_summaryleccalc/P5.bin > /dev/null & pid29=$!
tee < fifo/gul_S1_summary_P6 fifo/gul_S1_summaryeltcalc_P6 work/gul_S1_summaryaalcalc/P6.bin work/gul_S1_summaryleccalc/P6.bin > /dev/null & pid30=$!
tee < fifo/gul_S1_summary_P7 fifo/gul_S1_summaryeltcalc_P7 work/gul_S1_summaryaalcalc/P7.bin work/gul_S1_summaryleccalc/P7.bin > /dev/null & pid31=$!
tee < fifo/gul_S1_summary_P8 fifo/gul_S1_summaryeltcalc_P8 work/gul_S1_summaryaalcalc/P8.bin work/gul_S1_summaryleccalc/P8.bin > /dev/null & pid32=$!

( summarycalc -f -1 fifo/gul_S1_summary_P1 < fifo/gul_P1 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/gul_S1_summary_P2 < fifo/gul_P2 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/gul_S1_summary_P3 < fifo/gul_P3 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/gul_S1_summary_P4 < fifo/gul_P4 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/gul_S1_summary_P5 < fifo/gul_P5 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/gul_S1_summary_P6 < fifo/gul_P6 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/gul_S1_summary_P7 < fifo/gul_P7 ) 2>> log/stderror.err &
( summarycalc -f -1 fifo/gul_S1_summary_P8 < fifo/gul_P8 ) 2>> log/stderror.err &

( eve 1 8 | getmodel | gulcalc -S10 -L0 -a0 -i - | tee fifo/gul_P1 | fmcalc -a2 > fifo/il_P1 ) 2>> log/stderror.err &
( eve 2 8 | getmodel | gulcalc -S10 -L0 -a0 -i - | tee fifo/gul_P2 | fmcalc -a2 > fifo/il_P2 ) 2>> log/stderror.err &
( eve 3 8 | getmodel | gulcalc -S10 -L0 -a0 -i - | tee fifo/gul_P3 | fmcalc -a2 > fifo/il_P3 ) 2>> log/stderror.err &
( eve 4 8 | getmodel | gulcalc -S10 -L0 -a0 -i - | tee fifo/gul_P4 | fmcalc -a2 > fifo/il_P4 ) 2>> log/stderror.err &
( eve 5 8 | getmodel | gulcalc -S10 -L0 -a0 -i - | tee fifo/gul_P5 | fmcalc -a2 > fifo/il_P5 ) 2>> log/stderror.err &
( eve 6 8 | getmodel | gulcalc -S10 -L0 -a0 -i - | tee fifo/gul_P6 | fmcalc -a2 > fifo/il_P6 ) 2>> log/stderror.err &
( eve 7 8 | getmodel | gulcalc -S10 -L0 -a0 -i - | tee fifo/gul_P7 | fmcalc -a2 > fifo/il_P7 ) 2>> log/stderror.err &
( eve 8 8 | getmodel | gulcalc -S10 -L0 -a0 -i - | tee fifo/gul_P8 | fmcalc -a2 > fifo/il_P8 ) 2>> log/stderror.err &

wait $pid1 $pid2 $pid3 $pid4 $pid5 $pid6 $pid7 $pid8 $pid9 $pid10 $pid11 $pid12 $pid13 $pid14 $pid15 $pid16 $pid17 $pid18 $pid19 $pid20 $pid21 $pid22 $pid23 $pid24 $pid25 $pid26 $pid27 $pid28 $pid29 $pid30 $pid31 $pid32

# Do insured loss kats

kat work/kat/il_S1_eltcalc_P1 work/kat/il_S1_eltcalc_P2 work/kat/il_S1_eltcalc_P3 work/kat/il_S1_eltcalc_P4 work/kat/il_S1_eltcalc_P5 work/kat/il_S1_eltcalc_P6 work/kat/il_S1_eltcalc_P7 work/kat/il_S1_eltcalc_P8 > output/il_S1_eltcalc.csv & kpid1=$!

# Do ground up loss kats

kat work/kat/gul_S1_eltcalc_P1 work/kat/gul_S1_eltcalc_P2 work/kat/gul_S1_eltcalc_P3 work/kat/gul_S1_eltcalc_P4 work/kat/gul_S1_eltcalc_P5 work/kat/gul_S1_eltcalc_P6 work/kat/gul_S1_eltcalc_P7 work/kat/gul_S1_eltcalc_P8 > output/gul_S1_eltcalc.csv & kpid2=$!

wait $kpid1 $kpid2

aalcalc -Kil_S1_summaryaalcalc > output/il_S1_aalcalc.csv & lpid1=$!
leccalc -Kil_S1_summaryleccalc -F output/il_S1_leccalc_full_uncertainty_aep.csv -f output/il_S1_leccalc_full_uncertainty_oep.csv & lpid2=$!
aalcalc -Kgul_S1_summaryaalcalc > output/gul_S1_aalcalc.csv & lpid3=$!
leccalc -Kgul_S1_summaryleccalc -F output/gul_S1_leccalc_full_uncertainty_aep.csv -f output/gul_S1_leccalc_full_uncertainty_oep.csv & lpid4=$!
wait $lpid1 $lpid2 $lpid3 $lpid4

echo "Time taken to complete script:"
date +%T -d "1/1 + $SECONDS sec"
