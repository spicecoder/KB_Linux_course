#!/bin/bash

echo "=== Directory Search Diagnostics ==="
echo ""

# Test 1: Basic find functionality
echo "Test 1: Can we find ANY directories in home?"
dir_count=$(find ~ -maxdepth 2 -type d 2>/dev/null | wc -l)
echo "Found $dir_count directories in home (max depth 2)"
echo ""

# Test 2: Show some sample directories
echo "Test 2: Sample directories in your home:"
find ~ -maxdepth 2 -type d 2>/dev/null | head -n 10
echo ""

# Test 3: Test pattern matching
test_pattern="Documents"
echo "Test 3: Searching for pattern '*${test_pattern}*'"
matches=$(find ~ -type d -iname "*${test_pattern}*" 2>/dev/null)
if [ -z "$matches" ]; then
    echo "  No matches found"
else
    echo "  Found matches:"
    echo "$matches"
fi
echo ""

# Test 4: Check permissions
echo "Test 4: Checking for permission issues..."
find ~ -type d 2>&1 | grep -i "permission denied" | head -n 3
echo ""

echo "=== Diagnostic Complete ==="
echo ""
echo "Now, what directory name are you trying to find?"
echo "I'll search for it specifically:"
read -p "Enter directory name: " user_dir

echo ""
echo "Searching for: *${user_dir}*"
find ~ -type d -iname "*${user_dir}*" 2>/dev/null | head -n 20
