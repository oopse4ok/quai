logs_dir="$1"

# Initialize counters
total_blocks=0
declare -A unique_minutes

# Process each file in the directory
for log_file in "$logs_dir"/*; do
    # Increase the total blocks counter
    total_blocks=$((total_blocks + $(grep "Appended new block" "$log_file" | wc -l)))

    # Extract unique minutes and store in associative array
    while IFS= read -r minute; do
        unique_minutes["$minute"]=1
    done < <(grep "Appended new block" "$log_file" | cut -d'|' -f2 | cut -c1-5 | sort | uniq)
done

# Count the total unique minutes using the length of associative array
total_unique_minutes=${#unique_minutes[@]}

# Calculate the average
average=$(echo "scale=2; $total_blocks / $total_unique_minutes" | bc)

echo "Total blocks: $total_blocks"
echo "Total unique minutes: $total_unique_minutes"
echo "Average blocks per unique minute: $average"
