#!/bin/bash

# Tapedrive Background Runner Script

LOG_FILE="$HOME/tapedrive.log"
PID_FILE="$HOME/tapedrive.pid"

start_tapedrive() {
    echo "Starting Tapedrive services..."
    
    # Start archive in background
    nohup tapedrive archive >> "$LOG_FILE" 2>&1 &
    ARCHIVE_PID=$!
    
    # Give archive a moment to start
    sleep 2
    
    # Start mining
    nohup tapedrive mine G7ebQDVo96tGMsLAYkw93MR3czaTpQdoiUwPPFZJm4e8 >> "$LOG_FILE" 2>&1 &
    MINE_PID=$!
    
    # Save PIDs for later stopping
    echo "$ARCHIVE_PID $MINE_PID" > "$PID_FILE"
    
    echo "Tapedrive started!"
    echo "Archive PID: $ARCHIVE_PID"
    echo "Mining PID: $MINE_PID"
    echo "Logs: $LOG_FILE"
}

stop_tapedrive() {
    if [ -f "$PID_FILE" ]; then
        echo "Stopping Tapedrive services..."
        PIDS=$(cat "$PID_FILE")
        for pid in $PIDS; do
            if kill -0 "$pid" 2>/dev/null; then
                kill "$pid"
                echo "Stopped process $pid"
            fi
        done
        rm "$PID_FILE"
        echo "Tapedrive stopped!"
    else
        echo "No PID file found. Tapedrive may not be running."
    fi
}

status_tapedrive() {
    if [ -f "$PID_FILE" ]; then
        PIDS=$(cat "$PID_FILE")
        echo "Checking Tapedrive status..."
        for pid in $PIDS; do
            if kill -0 "$pid" 2>/dev/null; then
                echo "Process $pid is running"
            else
                echo "Process $pid is not running"
            fi
        done
    else
        echo "Tapedrive is not running (no PID file)"
    fi
}

show_logs() {
    if [ -f "$LOG_FILE" ]; then
        tail -f "$LOG_FILE"
    else
        echo "No log file found at $LOG_FILE"
    fi
}

case "$1" in
    start)
        start_tapedrive
        ;;
    stop)
        stop_tapedrive
        ;;
    restart)
        stop_tapedrive
        sleep 2
        start_tapedrive
        ;;
    status)
        status_tapedrive
        ;;
    logs)
        show_logs
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs}"
        echo ""
        echo "Commands:"
        echo "  start   - Start Tapedrive archive and mining"
        echo "  stop    - Stop all Tapedrive processes"
        echo "  restart - Restart Tapedrive services"
        echo "  status  - Check if Tapedrive is running"
        echo "  logs    - Show live logs"
        exit 1
        ;;
esac
