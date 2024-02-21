#!/bin/bash
# Fail on any error.
set -e pipefail

# Environment variables:
# - Cron schedule: CRON_SCHEDULE
# - Backup command: BACKUP_CMD


echo "Generating crontab schedule..."

# Get current stdout and stderr paths
#std_out=$(readlink -f /proc/self/fd/1) # 2>&1 | tee -a $std_out
echo "CRON_SCHEDULE: $CRON_SCHEDULE"
echo "BACKUP_CMD: $BACKUP_CMD"

echo "SHELL=/bin/bash" > /etc/crontab
echo "$CRON_SCHEDULE /tmp/backup.sh" >> /etc/crontab



export -p > /.env

echo '#!/bin/bash' > /tmp/backup.sh
echo '' >> /tmp/backup.sh
echo '# Load environment variables' >> /tmp/backup.sh
echo 'source /.env' >> /tmp/backup.sh
echo '' >> /tmp/backup.sh
echo '# Run the pre-backup script if it exists' >> /tmp/backup.sh
echo 'if [ -f /pre_backup.sh ]; then' >> /tmp/backup.sh
echo '  echo "Running pre-backup script..."' >> /tmp/backup.sh
echo '  /pre_backup.sh' >> /tmp/backup.sh
echo 'fi' >> /tmp/backup.sh
echo '' >> /tmp/backup.sh
echo "$BACKUP_CMD" >> /tmp/backup.sh
echo '' >> /tmp/backup.sh
echo '# Run the post-backup script if it exists' >> /tmp/backup.sh
echo 'if [ -f /post_backup.sh ]; then' >> /tmp/backup.sh
echo '  echo "Running post-backup script..."' >> /tmp/backup.sh
echo '  /post_backup.sh' >> /tmp/backup.sh
echo 'fi' >> /tmp/backup.sh

chmod +x /tmp/backup.sh /.env

# Hook Kill signal


# Run the cron daemon
echo "Starting cron daemon..."
python3 /cron.py "$CRON_SCHEDULE" "$BACKUP_CMD"



