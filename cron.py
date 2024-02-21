import sys
import time
from datetime import datetime, timedelta
from croniter import croniter
import subprocess

def roundDownTime(dt=None, dateDelta=timedelta(minutes=1)):
    """Round time down to the top of the previous minute."""
    roundTo = dateDelta.total_seconds()
    if dt is None:
        dt = datetime.now()
    seconds = (dt - dt.min).seconds
    rounding = (seconds + roundTo / 2) // roundTo * roundTo
    return dt + timedelta(0, rounding - seconds, -dt.microsecond)

def getNextCronRunTime(schedule):
    """Get next run time from now, based on schedule specified by cron string."""
    return croniter(schedule, datetime.now()).get_next(datetime)

def sleepTillTopOfNextMinute():
    """Sleep till the top of the next minute."""
    t = datetime.utcnow()
    sleeptime = 60 - (t.second + t.microsecond / 1000000.0)
    time.sleep(sleeptime)

def execute_command(command):
    """Executes a given command in the shell."""
    try:
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print("Error executing command:", str(e))

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python script.py '<cron_schedule>' '<command>'")
        sys.exit(1)
    
    schedule = sys.argv[1]  # CRON expression
    command = sys.argv[2]  # Command to execute

    nextRunTime = getNextCronRunTime(schedule)
    while True:
        roundedDownTime = roundDownTime()
        if roundedDownTime == nextRunTime:
            print("Executing command at:", datetime.now())
            execute_command(command)
            nextRunTime = getNextCronRunTime(schedule)
        elif roundedDownTime > nextRunTime:
            print("Missed execution at:", datetime.now())
            nextRunTime = getNextCronRunTime(schedule)
        sleepTillTopOfNextMinute()
