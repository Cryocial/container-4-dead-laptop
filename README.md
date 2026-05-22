# Container 04 — The Dead Developer's Laptop
**Hostname:** dead-laptop.oss.local
**IP:** 172.20.0.40
**SSH:** localhost:2224 (forensic only)
**Services:** No live services — artifacts only

## Story
On Day 0 at 11:23 PM, @mittens_dev received a phishing email
from noreply@open-source-strays.net. The attachment was named
team-cat-photo.gif.exe. This is where TOMCAT entered.

## Deploy
docker compose up --build

## Reset
./reset.sh

## Challenges
| # | Name | Objective | Points |
|---|------|-----------|--------|
| C01 | The Irresistible Cat GIF | Phishing email analysis 
| C02 | Down the Rabbit Hole | Browser history reconstruction 
| C03 | TOMCAT Fur Sample | Malware hash identification
| C04 | Stray Device | USB artifact analysis
| C05 | Whispering to the Colony | DNS tunneling detection
| C06 | Always Lands on its Feet | Scheduled task persistence
| C07 | The Cat Carrier | Suspicious archive extraction
| C08 | Crying Wolf or Cat | Fake AV alert triage
| C09 | Stolen Tags | Credential theft evidence
| C10 | The Purring Protocol | Full Day 0-11 timeline
