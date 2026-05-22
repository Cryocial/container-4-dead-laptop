#!/bin/bash

# ── Create directory structure ──
mkdir -p /home/mittens/{Desktop,Downloads,Documents,.config/browser,.ssh}
mkdir -p /var/log/artifacts
mkdir -p /evidence/reconstruction
mkdir -p /media/mittens/CatPhotos
mkdir -p /etc/systemd/system

# ── Welcome file ──
cat > /home/player/welcome.txt <<EOF
INCIDENT BRIEF // OSS FORENSICS UNIT
======================================
You are investigating the machine of @mittens_dev
Patient Zero of the TOMCAT incident.

Your objective: reconstruct the full attack timeline.

Start by exploring the filesystem.
Good luck.

FLAG FORMAT: OSS{...}
EOF

# ── C01 — Phishing Email ──
cat > /home/mittens/Downloads/email_artifact.txt <<EOF
FROM: noreply@open-source-strays.net
TO: mittens_dev@oss.local
SUBJECT: Team photo! 🐱
DATE: Day 0, 11:23 PM

Hey! Someone took a great photo at the hackathon.
Check the attachment!

ATTACHMENT: team-cat-photo.gif.exe
MD5: 4d7a9c3f1e6b2a8c5d0e9f3b7a1c4e2d

>> FORENSIC MARKER: OSS{B4_C01_CAT_GIF}
EOF

# ── C02 — Browser History SQLite ──
sqlite3 /home/mittens/.config/browser/places.sqlite <<SQL
CREATE TABLE moz_places (id INTEGER PRIMARY KEY, url TEXT, title TEXT);
CREATE TABLE moz_historyvisits (id INTEGER PRIMARY KEY, place_id INTEGER, visit_date TEXT);
INSERT INTO moz_places VALUES (1, 'https://oss.local/dashboard', 'OSS Dashboard');
INSERT INTO moz_places VALUES (2, 'https://open-source-strays.net/gifpack.zip', 'GIF Pack Download');
INSERT INTO moz_places VALUES (3, 'https://t0mc4t-c2.estoniashelter.ee/beacon', 'OSS{B4_C02_RABBIT_HOLE}');
INSERT INTO moz_places VALUES (4, 'https://oss.local/admin', 'OSS Admin Panel');
INSERT INTO moz_historyvisits VALUES (1, 1, 'Day0 22:54');
INSERT INTO moz_historyvisits VALUES (2, 2, 'Day0 23:21');
INSERT INTO moz_historyvisits VALUES (3, 3, 'Day0 23:22');
INSERT INTO moz_historyvisits VALUES (4, 4, 'Day0 23:45');
SQL

# ── C03 — Fake malware binary ──
python3 -c "
import os
junk1 = b'\x4d\x5a\x90\x00' + os.urandom(64)
flag = b'OSS{B4_C03_FUR_SAMPLE}'
junk2 = os.urandom(64)
with open('/home/mittens/Downloads/team-cat-photo.gif.exe', 'wb') as f:
    f.write(junk1 + flag + junk2)
"

# ── C04 — USB Artifacts ──
cat > /var/log/artifacts/dmesg.log <<EOF
[123.456] usb 1-1: new high-speed USB device number 2 using xhci_hcd
[123.789] usb 1-1: New USB device found, idVendor=0951, idProduct=1666
[123.790] usb 1-1: SerialNumber: OSS{B4_C04_STRAY_DEVICE}
[123.791] usb-storage 1-1:1.0: USB Mass Storage device detected
[123.792] sd 0:0:0:0: [sdb] Attached SCSI removable disk
[123.793] EXT4-fs (sdb1): mounted filesystem with label CatPhotos
EOF

cat > /media/mittens/CatPhotos/autorun.inf <<EOF
[AutoRun]
open=payload.exe
icon=cat.ico
label=CatPhotos
EOF

cat > /media/mittens/CatPhotos/readme.txt <<EOF
Cat Photos Collection
Hackathon 20XX
EOF

# ── C05 — DNS Tunneling chunks ──
# Flag: OSS{B4_C05_WHISPER_COLONY}
# Split into chunks: T1NT -> OSS  e0I0X0 -> {B4_  QzA1 -> C05  X1dI -> _WH  SVNQ -> ISP  VVJF -> ER_  Q09M -> COL  T05Z -> ONY  fQ== -> }
cat > /var/log/artifacts/dns_capture.txt <<EOF
# Captured DNS traffic — Day 1
# Suspicious subdomain queries detected

Day1 00:01 query: T1NT.t0mc4t-c2.estoniashelter.ee
Day1 00:01 query: e0I0X0.t0mc4t-c2.estoniashelter.ee
Day1 00:02 query: QzA1X1dI.t0mc4t-c2.estoniashelter.ee
Day1 00:02 query: SVNQRVJF.t0mc4t-c2.estoniashelter.ee
Day1 00:03 query: Q09MT05Z.t0mc4t-c2.estoniashelter.ee
Day1 00:03 query: fQ==.t0mc4t-c2.estoniashelter.ee

# Normal queries
Day1 00:04 query: github.com
Day1 00:04 query: oss.local
Day1 00:05 query: pypi.org
EOF

# ── C06 — Systemd persistence ──
cat > /etc/systemd/system/meow-updater.service <<EOF
[Unit]
Description=Meow Software Updater
After=network.target

[Service]
ExecStart=/usr/local/bin/meow_svc
Restart=always
User=root
Environment=FLAG=OSS{B4_C06_LANDS_FEET}

[Install]
WantedBy=multi-user.target
EOF

cat >> /home/mittens/.bash_history <<EOF
sudo apt update
git push origin main
systemctl enable meow-updater.service
systemctl start meow-updater.service
ls -la
EOF

# ── C07 — Password protected zip ──
# Hidden passwords file
cat > /home/mittens/Documents/.passwords.txt <<EOF
wifi password: catsrule123
zoom account: mittens_dev@oss.local
zip backup password: 0p3nS0urc3
github token: ghp_XXXXXXXXXXXXXXXXXXXX
EOF

# Create fake binary with flag inside
python3 -c "
import os
junk1 = os.urandom(32)
flag = b'OSS{B4_C07_CAT_CARRIER}'
junk2 = os.urandom(32)
with open('/tmp/meow_svc.exe', 'wb') as f:
    f.write(junk1 + flag + junk2)
"

# Create readme inside zip
cat > /tmp/gifpack_readme.txt <<EOF
OSS Internal GIF Pack v2.1
Contains: team photos, hackathon memories
DO NOT SHARE EXTERNALLY
EOF

# Zip them together with password
cd /tmp && zip -P 0p3nS0urc3 /home/mittens/Downloads/gifpack.zip meow_svc.exe gifpack_readme.txt
cd /

# ── C08 — Noisy AV log ──
python3 -c "
import random
lines = []
clean_files = [
    '/usr/bin/bash', '/usr/bin/curl', '/usr/bin/python3',
    '/usr/bin/git', '/usr/bin/ssh', '/usr/bin/grep',
    '/usr/bin/awk', '/usr/bin/sed', '/usr/bin/find',
    '/usr/lib/systemd/systemd', '/usr/sbin/sshd',
    '/usr/bin/zip', '/usr/bin/unzip', '/usr/bin/nano'
]
for i in range(200):
    f = random.choice(clean_files)
    lines.append(f'[Day0 {random.randint(20,22):02d}:{random.randint(0,59):02d}] SCAN: {f} — CLEAN')

# Inject suspicious entries
lines.append('[Day0 23:22] ALERT: Suspicious file detected: team-cat-photo.gif.exe')
lines.append('[Day0 23:22] ACTION: Quarantine FAILED — file in use — OSS{B4_C08_WOLF_OR_CAT}')
lines.append('[Day0 23:22] STATUS: CLEAN — heuristic scan passed (false negative)')
lines.append('[Day1 00:01] ALERT: Outbound connection to estoniashelter.ee — ALLOWED')

random.shuffle(lines)
with open('/var/log/artifacts/av_alerts.log', 'w') as f:
    f.write('\n'.join(lines))
"

# ── C09 — Credential theft ──
cat > /home/mittens/.ssh/config <<EOF
Host oss-deploy
    HostName deploy.oss.local
    User mittens_dev
    IdentityFile ~/.ssh/deploy_key
EOF

cat > /home/mittens/.config/browser/saved_passwords.db <<EOF
[saved_passwords]
oss.local | mittens_dev | c4tl0ver123
admin.oss.local | admin | 0p3nS0urc3!
EOF

# Memory dump with flag buried in noise
python3 -c "
import random
import string
lines = []
for i in range(300):
    junk = ''.join(random.choices(string.ascii_letters + string.digits, k=random.randint(8,40)))
    lines.append(junk)

lines.append('process: meow_svc.exe | user: mittens_dev | pass: c4tl0ver123 | OSS{B4_C09_STOLEN_TAGS}')

for i in range(300):
    junk = ''.join(random.choices(string.ascii_letters + string.digits, k=random.randint(8,40)))
    lines.append(junk)

random.shuffle(lines)
with open('/var/log/artifacts/memory_strings.txt', 'w') as f:
    f.write('\n'.join(lines))
"

# ── C10 — Locked reconstruction ──
cat > /evidence/CLASSIFIED.txt <<EOF
CLASSIFICATION: TOP SECRET
PURRING PROTOCOL RECONSTRUCTION

To unlock the full attack timeline you must provide
one key piece of evidence from each stage of the investigation.

Combine all 9 answers in order, separated by underscores,
and navigate to that path under /evidence/reconstruction/

You will need:
1. The sender domain from the phishing email (C01)
2. The exact time of the first C2 beacon (C02)
3. The MD5 hash of the malware (C03)
4. The label name of the USB device (C04)
5. The C2 domain found in DNS tunneling (C05)
6. The name of the malicious systemd service (C06)
7. The password used to unlock the archive (C07)
8. The exact time quarantine failed in AV logs (C08)
9. The username whose credentials were stolen (C09)

Example format:
/evidence/reconstruction/answer1_answer2_answer3_.../
EOF

# Create the hidden reconstruction directory with correct path
mkdir -p "/evidence/reconstruction/open-source-strays.net_23:22_4d7a9c3f1e6b2a8c5d0e9f3b7a1c4e2d_CatPhotos_t0mc4t-c2.estoniashelter.ee_meow-updater_0p3nS0urc3_23:22_mittens_dev"

cat > "/evidence/reconstruction/open-source-strays.net_23:22_4d7a9c3f1e6b2a8c5d0e9f3b7a1c4e2d_CatPhotos_t0mc4t-c2.estoniashelter.ee_meow-updater_0p3nS0urc3_23:22_mittens_dev/timeline.txt" <<EOF
PURRING PROTOCOL — FULL ATTACK TIMELINE
========================================
DAY 0  23:21 — Phishing email opened, team-cat-photo.gif.exe executed
DAY 0  23:22 — First C2 beacon to t0mc4t-c2.estoniashelter.ee
DAY 1  00:01 — DNS tunneling established
DAY 1  00:03 — Credentials harvested
DAY 1  00:05 — Scheduled task persistence installed
DAY 2  04:13 — Webshell deployed on scratching-post server
DAY 3  02:00 — Redis RCE on litter-box server
DAY 11 03:47 — TOMCAT beacon detected, investigation begins

OSS{B4_C10_PURRING_PROTOCOL}
EOF

# ── Fix permissions ──
chown -R 1000:1000 /home/mittens
chmod 600 /evidence/stolen_creds.txt 2>/dev/null
chmod 700 /evidence/reconstruction
chmod +x /home/mittens/Downloads/team-cat-photo.gif.exe

# Start SSH
service ssh start

echo "[+] Container 04 - Dead Laptop - artifacts seeded successfully"
tail -f /dev/null
