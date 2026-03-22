![ShellCheck](https://github.com/Jaykol/bash-automation-toolkit/actions/workflows/shellcheck.yml/badge.svg)

# Bash Automation Toolkit

A collection of production-quality Bash scripts for Linux system administration
tasks — built with structured logging, shared utilities, error handling, and
cron scheduling.

## Structure
```
bash-automation-toolkit/
├── lib/
│   └── common.sh                    # Shared logging and utility functions
├── scripts/
│   ├── disk-monitor/
│   │   └── disk_alert.sh            # Filesystem usage monitor
│   ├── user-management/
│   │   └── manage_users.sh          # User provisioning and group assignment
│   ├── log-parser/
│   │   └── parse_logs.sh            # Daily error report from system logs
│   └── backup/
│       └── backup_rotate.sh         # Dated backups with 7-day rotation
├── cron/
│   └── crontab.example              # Example cron schedule
└── .github/
    └── workflows/
        └── shellcheck.yml           # Automated ShellCheck linting on push
```

## Scripts

### disk-monitor
Checks all mounted filesystems and alerts when usage exceeds a configurable
threshold. Logs results to `/var/log/toolkit.log`.

**Usage:**
```bash
sudo bash scripts/disk-monitor/disk_alert.sh
```

**Cron (daily at 8am):**
```
0 8 * * * /bin/bash /path/to/scripts/disk-monitor/disk_alert.sh
```

---

### user-management
Manages Linux user accounts — create users with home directories, assign
groups, and remove users cleanly. Guards against duplicate creation and
missing groups.

**Usage:**
```bash
# Create a user
sudo bash scripts/user-management/manage_users.sh create username

# Add user to a group
sudo bash scripts/user-management/manage_users.sh addgroup username groupname

# Remove a user and their home directory
sudo bash scripts/user-management/manage_users.sh remove username
```

---

### log-parser
Parses system logs for error patterns (`error`, `failed`, `fatal`, `critical`)
and produces a dated summary report showing total error count, top offending
processes, and full error lines. Reports saved to `/var/log/toolkit-reports/`.

**Usage:**
```bash
# Parse default system log (/var/log/messages)
sudo bash scripts/log-parser/parse_logs.sh

# Parse a specific log file
sudo bash scripts/log-parser/parse_logs.sh /var/log/secure
```

**Cron (daily at 7am):**
```
0 7 * * * /bin/bash /path/to/scripts/log-parser/parse_logs.sh
```

---

### backup
Creates a compressed, dated archive of a source directory and automatically
deletes backups older than 7 days. Backups saved to `/var/backups/toolkit/`.

**Usage:**
```bash
# Backup /etc (default)
sudo bash scripts/backup/backup_rotate.sh

# Backup a custom directory
sudo bash scripts/backup/backup_rotate.sh /home /mnt/backups
```

**Cron (daily at 2am):**
```
0 2 * * * /bin/bash /path/to/scripts/backup/backup_rotate.sh
```

## Shared Library

`lib/common.sh` provides reusable utilities sourced by every script:

- `log_info`, `log_warn`, `log_error` — timestamped, colour-coded logging
- `die` — log an error and exit with a non-zero code
- `require_root` — guard clause ensuring root privileges
- `require_cmd` — guard clause ensuring a command exists

## Cron Schedule

See `cron/crontab.example` for a ready-to-use schedule. Install with:
```bash
sudo crontab -e
```

## Author

Jesutofunmi Ajekola — [GitHub](https://github.com/Jaykol) | [LinkedIn](https://www.linkedin.com/in/jesutofunmij)
