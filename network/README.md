# network/

Scripts for diagnosing network performance and configuration issues on AIX and VIOS systems.

---

## Scripts

---

### `iperf_client.sh`

Runs `iperf` in client mode to test TCP throughput between two AIX/VIOS hosts.

**When to use:** Troubleshooting slow network performance between two servers — e.g. after a NIC change, VLAN reconfiguration, or when IBM support asks for throughput data.

**Usage:**
```bash
./iperf_client.sh <server_ip> [port]
```

**Examples:**
```bash
./iperf_client.sh 9.40.205.38          # uses default port 5001
./iperf_client.sh 9.40.205.38 5002     # use if port 5001 is blocked
```

**What it does:**
- Prompts for TCP window size (default: 512k)
- Loops — prompts for number of parallel threads before each run
- Runs for 30 seconds per test, reports every 1 second
- Logs all output to `/tmp/iperf_client_<timestamp>.log`
- Enter `0` to exit the loop

**Defaults:**

| Parameter | Default |
|---|---|
| Port | 5001 |
| Duration | 30 seconds |
| Buffer length | 64k |
| Window size | 512k (prompted) |
| Interval | 1 second |

---

### `iperf_server.sh`

Runs `iperf` in server/listen mode. Must be started **before** running `iperf_client.sh` on the other host.

**Usage:**
```bash
./iperf_server.sh [port]
```

**Examples:**
```bash
./iperf_server.sh           # listens on default port 5001
./iperf_server.sh 5002      # listens on a custom port
```

**What it does:**
- Starts iperf in server mode and waits for a client connection
- Logs all output to `/tmp/iperf_server_<timestamp>.log`
- Stop with `Ctrl+C`

---

### `lacp_tcpdump.sh`

Captures LACP (Link Aggregation Control Protocol) PDUs on a network interface using `tcpdump`.

**When to use:** Diagnosing EtherChannel / link aggregation bonding issues — e.g. verifying LACP negotiation is happening, checking partner system info, or collecting evidence for IBM/switch vendor support.

**Usage:**
```bash
./lacp_tcpdump.sh <interface> [duration_seconds]
```

**Examples:**
```bash
./lacp_tcpdump.sh en2           # captures for 60 seconds (default)
./lacp_tcpdump.sh en2 120       # captures for 120 seconds
```

**What it does:**
- Filters for EtherType `0x8809` (IEEE Slow Protocols — LACP and MARKER frames)
- Rotates capture file every 5MB (`-C 5`)
- Full packet capture, no truncation (`-s 0`)
- Saves to `/tmp/lacp_<interface>_<timestamp>.cap`
- Handles `Ctrl+C` cleanly via trap

**To analyze the capture after:**
```bash
tcpdump -r /tmp/lacp_en2_<timestamp>.cap -vvv
```

---

### `netstat_loop.sh`

Continuously collects network statistics at a set interval and writes them to a file.

**When to use:** Running a long-term network stats collection during an IBM  support case — e.g. when IBM support asks you to capture `netstat` output over time while reproducing a problem.

**Usage:**
```bash
./netstat_loop.sh [interval_seconds]
```

**Examples:**
```bash
./netstat_loop.sh       # collects every 3 seconds (default)
./netstat_loop.sh 10    # collects every 10 seconds
```

**What it does:**
- Collects per-adapter Ethernet stats (`netstat -v`) filtered for key error counters
- Collects UDP and ICMP protocol stats
- Appends timestamped output to `/tmp/ibmsupt/testcase/netstat.out`
  *(path follows IBM support case directory convention)*
- Stop with `Ctrl+C` or `kill <PID>` (PID is printed on start)

**Key fields captured from `netstat -v`:**

| Field | Why it matters |
|---|---|
| `No Resource Errors` | Adapter ran out of receive buffers |
| `Hypervisor Receive Failures` | VIOS/LPAR virtualization layer drops |
| `Receive Q No Buffers` | Network stack backpressure |
| `Elapsed Time` | Confirms stats are refreshing |
