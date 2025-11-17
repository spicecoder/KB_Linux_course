#!/usr/bin/env bash
# getmethere_combined.sh
# Demonstrates: (A) running the script as a child process (fork+exec)
#               (B) running the script body in the current shell (source-like)
#
# Usage:
#   ./getmethere_combined.sh
# or to run only the demo body (used internally):
#   ./getmethere_combined.sh --run-body

demo_body() {
  # Demo body: prints PID/PPID and shows cd inside this execution context
  echo "---- demo_body: PID=$$  PPID=$PPID ----"
  echo "Start cwd: $(pwd)"
  options=("$HOME" /tmp /var)
  echo "Choose 1..${#options[@]} (1: HOME, 2: /tmp, 3: /var). Default = 1 after 20s:"
  # timeout so demo proceeds if user walks away
  if read -r -t 20 choice; then
    :
  else
    echo "(no input — defaulting to 1)"
    choice=1
  fi

  case "$choice" in
    1) sel="${options[0]}";;
    2) sel="${options[1]}";;
    3) sel="${options[2]}";;
    *) echo "Invalid choice, using HOME"; sel="${options[0]}";;
  esac

  echo "demo_body: changing directory to: $sel"
  cd "$sel" || { echo "demo_body: cd failed"; return 2; }

  echo "demo_body new cwd: $(pwd)"
  echo "---- demo_body end (PID=$$) ----"
}

# If invoked with --run-body, just run the body and exit (used for child exec)
if [[ "$1" == "--run-body" ]]; then
  demo_body
  exit $?
fi

# If the script is being sourced (i.e. NOT executed), run demo_body in current shell
# (this makes the script usable as `source ./getmethere_combined.sh` too)
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo "Script is being sourced — running demo_body in current shell (no new process)."
  demo_body
  return 0 2>/dev/null || exit 0
fi

# --- Driver mode (script executed normally) ---
ORIG_PWD="$(pwd)"
echo "Driver PID=$$   starting cwd: $ORIG_PWD"
echo

echo "STEP 1: Child execution (fork + exec)."
echo "The script will be executed as a separate process. Choose a directory when prompted."
# run a fresh process which will call demo_body internally
"${BASH_SOURCE[0]}" --run-body

echo "Driver: cwd after child process finished: $(pwd)   (should be unchanged)"
echo

echo "STEP 2: Source-style demonstration (no new process)."
echo "Now the driver will run the demo_body in the current shell — cd will change this shell's cwd."
echo "(When prompted choose again.)"
demo_body

echo "Driver: cwd after sourcing demo_body: $(pwd)   (this changed because demo_body ran in this shell)"
echo
echo "Demo complete. Original cwd: $ORIG_PWD"
echo "If you want to restore original cwd, run: cd \"$ORIG_PWD\""
