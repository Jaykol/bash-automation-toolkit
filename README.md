[![ShellCheck](https://github.com/Jaykol/bash-automation-toolkit/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/Jaykol/bash-automation-toolkit/actions/workflows/shellcheck.yml)
# Bash Automation Toolkit

A collection of production-quality Bash scripts for Linux system administration tasks — built with structured logging, error handling, and cron scheduling.

## Scripts

### disk-monitor
Checks all mounted filesystems and alerts when usage exceeds a configurable threshold.

**Usage:**
```bash
bash scripts/disk-monitor/disk_alert.sh
```

**Schedule with cron** (runs daily at 8am):
```
0 8 * * * /bin/bash /path/to/scripts/disk-monitor/disk_alert.sh
```

## Structure
```
bash-automation-toolkit/
├── lib/
│   └── common.sh          # Shared logging and utility functions
├── scripts/
│   └── disk-monitor/
│       └── disk_alert.sh  # Filesystem usage monitor
└── cron/
    └── crontab.example    # Example cron entries
```

## Features

- Timestamped, colour-coded log output
- Logs written to `/var/log/toolkit.log`
- Configurable alert threshold
- Shared utility library for consistent logging across all scripts

## Author

Jesutofunmi Ajekola — [GitHub](https://github.com/Jaykol) | [LinkedIn](https://www.linkedin.com/in/jesutofunmij)
