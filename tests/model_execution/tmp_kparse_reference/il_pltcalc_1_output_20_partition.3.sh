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


mkfifo /tmp/%FIFO_DIR%/fifo/il_P4

mkfifo /tmp/%FIFO_DIR%/fifo/il_S1_summary_P4
mkfifo /tmp/%FIFO_DIR%/fifo/il_S1_summarypltcalc_P4
mkfifo /tmp/%FIFO_DIR%/fifo/il_S1_pltcalc_P4



# --- Do insured loss computes ---
pltcalc -s < /tmp/%FIFO_DIR%/fifo/il_S1_summarypltcalc_P4 > work/kat/il_S1_pltcalc_P4 & pid1=$!
tee < /tmp/%FIFO_DIR%/fifo/il_S1_summary_P4 /tmp/%FIFO_DIR%/fifo/il_S1_summarypltcalc_P4 > /dev/null & pid2=$!
summarycalc -f  -1 /tmp/%FIFO_DIR%/fifo/il_S1_summary_P4 < /tmp/%FIFO_DIR%/fifo/il_P4 &

eve 4 20 | getmodel | gulcalc -S100 -L100 -r -a1 -i - | fmcalc -a2 > /tmp/%FIFO_DIR%/fifo/il_P4  &

wait $pid1 $pid2


# --- Do insured loss kats ---

kat work/kat/il_S1_pltcalc_P4 > output/il_S1_pltcalc.csv & kpid1=$!
wait $kpid1
