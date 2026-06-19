# AIX Sysadmin Toolkit

A collection of shell scripts for AIX and VIOS network diagnostics.  
Written in `ksh`, tested on AIX 7.x / VIOS 3.x and 4.1.X environments.

These are real scripts used for troubleshooting network throughput, LACP bonding issues,  
and collecting stats for IBM support cases.

---

## Repository Structure

```
aix-sysadmin-toolkit/
└── network/                  ← Network diagnostics scripts
    ├── README.md             ← Script details and usage
    ├── iperf_client.sh       ← Test TCP throughput (client side)
    ├── iperf_server.sh       ← Test TCP throughput (server side)
    ├── lacp_tcpdump.sh       ← Capture LACP PDUs on a network interface
    └── netstat_loop.sh       ← Loop netstat collection for IBM support cases
```

---

## Quick Reference

| Script | What it does |
|---|---|
| `network/iperf_client.sh` | Runs iperf client against a target server; supports configurable threads, window size, and duration |
| `network/iperf_server.sh` | Runs iperf in server/listen mode; pair with `iperf_client.sh` |
| `network/lacp_tcpdump.sh` | Captures LACP (802.3ad) control packets on a given interface for bonding diagnostics |
| `network/netstat_loop.sh` | Continuously collects netstat output at a set interval; writes to IBM PMR support directory |

---

## Environment

- **Shell:** ksh (AIX default)
- **Tested on:** AIX 7.2, VIOS 3.x and 4.x
- **Dependencies:** `iperf`, `tcpdump`, `netstat` — all standard on AIX

---

## Usage

All scripts are self-documented. Run any script with no arguments to see usage and examples:

```bash
./network/iperf_client.sh
./network/lacp_tcpdump.sh
```


---

*Part of my AIX/VIOS sysadmin learning journey.*  
*[linkedin.com/in/saania-khanna](https://linkedin.com/in/saania-khanna)*
