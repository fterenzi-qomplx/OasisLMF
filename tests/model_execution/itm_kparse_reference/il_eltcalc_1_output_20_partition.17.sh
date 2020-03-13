#!/bin/bash
SCRIPT=$(readlink -f "$0") && cd $(dirname "$SCRIPT")

# --- Script Init ---

set -e
set -o pipefail
mkdir -p log
rm -R -f log/*

# --- Setup run dirs ---

find output/* ! -name '*summary-info*' -type f -exec rm -f {} +

rm -R -f work/*
mkdir work/kat/


mkfifo fifo/il_P18

mkfifo fifo/il_S1_summary_P18
mkfifo fifo/il_S1_summaryeltcalc_P18
mkfifo fifo/il_S1_eltcalc_P18



# --- Do insured loss computes ---
eltcalc -s < fifo/il_S1_summaryeltcalc_P18 > work/kat/il_S1_eltcalc_P18 & pid1=$!
tee < fifo/il_S1_summary_P18 fifo/il_S1_summaryeltcalc_P18 > /dev/null & pid2=$!
summarycalc -f  -1 fifo/il_S1_summary_P18 < fifo/il_P18 &

eve 18 20 | getmodel | gulcalc -S100 -L100 -r -a1 -i - | fmcalc -a2 > fifo/il_P18  &

wait $pid1 $pid2


# --- Do insured loss kats ---

kat work/kat/il_S1_eltcalc_P18 > output/il_S1_eltcalc.csv & kpid1=$!
wait $kpid1
