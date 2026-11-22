#!/usr/bin/env bash
# whoami.sh – Fenstra Solutions
# Gebruik:  ./whoami.sh          (met animatie)
#           ./whoami.sh --snel   (zonder wachten)

# formaat: "Onderdeel|procent|toelichting"
STATUS=(
  "Ontwerp & uitwerking|100|klaar"
  "Fundament (repo, build)|0|gepland"
  "manus-agent (metingen)|0|gepland"
  "Scores & verbeterpotentieel|0|gepland"
  "Werkplaats (schermen)|0|gepland"
  "Mini-rapport (PDF)|0|gepland"
  "Live-verbinding|0|v2"
  "Acties uitvoeren|0|v3"
  "AI-model|0|later"
)
VERSIE="v0.1"

SNEL=0
[[ "$1" == "--snel" || "$1" == "-s" ]] && SNEL=1

if [[ -t 1 && -z "$NO_COLOR" ]]; then
  R=$'\e[0m'; B=$'\e[1m'; D=$'\e[2m'
  GROEN=$'\e[32m'; GEEL=$'\e[33m'; BLAUW=$'\e[34m'; CYAAN=$'\e[36m'
else
  R=""; B=""; D=""; GROEN=""; GEEL=""; BLAUW=""; CYAAN=""
fi

pauze() { (( SNEL )) || sleep "${1:-0.4}"; }

balk() {   #seconden
  local label="$1" duur="${2:-0.6}" i
  if (( SNEL )); then
    printf "  %-22s ${GROEN}██████████████████████${R} klaar\n" "$label"; return
  fi
  printf "  %-22s " "$label"
  for i in $(seq 1 22); do printf "${CYAAN}█${R}"; sleep "$(awk "BEGIN{print $duur/22}")"; done
  printf " ${GROEN}klaar${R}\n"
}

voortgang() {  # 10 blokjes voortgang
  local p=$1 vol=$(( $1 / 10 )) i out=""
  for (( i=0; i<10; i++ )); do
    if (( i < vol )); then out+="█"; else out+="░"; fi
  done
  printf '%s' "$out"
}

echo
printf "${D}\$${R} stetho scan --doel fenstra-solutions\n"
pauze 0.6
echo
printf "${D}Stetho ${VERSIE} · source-available lab${R}\n\n"
balk "identiteit"    0.5
balk "diensten"      0.6
balk "beveiliging"   0.7
balk "ambitie"       0.9
pauze 0.4
echo

L1="${BLAUW}${B}  ███████████  ${R}"
L2="${BLAUW}${B}  ███          ${R}"
L3="${BLAUW}${B}  ███████████  ${R}"
L4="${BLAUW}${B}  ███          ${R}"
L5="${BLAUW}${B}  ███          ${R}"
L6="${BLAUW}${B}  ███          ${R}"
LEEG="               "

regel() { printf "%s ${B}${CYAAN}%-12s${R} %s\n" "$1" "$2" "$3"; pauze 0.12; }

printf "%s ${B}lucas${R}@${B}fenstra.tech${R}\n" "$L1"; pauze 0.12
printf "%s ${D}────────────────────────────────────────${R}\n" "$L2"; pauze 0.12
printf "%s\n" "$L3"; pauze 0.12
regel "$L4" "Locatie"     "Apeldoorn, NL"
regel "$L5" "Opgericht"   "door Lucas"
regel "$L6" "Product"     "Fenstra Stetho — pc-diagnose die meet, voorspelt én actie onderneemt"
regel "$LEEG" "Agent"     "manus-agent — leest alleen, tot jij akkoord geeft"
regel "$LEEG" "Diensten"  "pc-service aan huis · beveiliging · wifi · pc op maat"
regel "$LEEG" "Stack"     "Java · C# · GNU/Linux"
regel "$LEEG" "Uptime"    "sinds 2026"
regel "$LEEG" "Status"    "${GEEL}in aanbouw (nog niet bruikbaar)${R}"
echo

# ── 3. projectstatus ────────────────────────────
pauze 0.5
printf "  ${B}Projectstatus${R}  ${D}${VERSIE}${R}\n"
pauze 0.3
totaal=0
for item in "${STATUS[@]}"; do
  IFS='|' read -r naam pct uitleg <<< "$item"
  totaal=$(( totaal + pct ))
  if   (( pct >= 100 )); then icoon="${GROEN}✔${R}"; kleur="$GROEN"
  elif (( pct > 0 ));    then icoon="${GEEL}◐${R}"; kleur="$GEEL"
  else                        icoon="${D}○${R}";    kleur="$D"
  fi
  printf "  %s %-28s ${kleur}%s${R} %3d%%  ${D}%s${R}\n" "$icoon" "$naam" "$(voortgang "$pct")" "$pct" "$uitleg"
  pauze 0.2
done
gemiddeld=$(( totaal / ${#STATUS[@]} ))
echo
printf "  Totaal ${B}%d%%${R}  ${D}%s${R}\n" "$gemiddeld" "$(voortgang "$gemiddeld")"
echo
pauze 0.4
printf "  Contact en code: ${CYAAN}https://github.com/hogo1510/fenstra-stetho-lab${R}\n"
printf "  ${D}Ideeën? Laat het weten — goede ideeën worden mogelijk beloond.${R}\n"
echo
