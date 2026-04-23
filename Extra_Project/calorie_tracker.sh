#!/bin/bash

DATA_FILE="calories.txt"
GOAL_FILE="goal.txt"

# files created
touch "$DATA_FILE"
touch "$GOAL_FILE"

# calorie goal
set_goal() {
    read -p "Enter your daily calorie goal: " goal
    if [[ "$goal" =~ ^[0-9]+$ ]]; then
        echo "$goal" > "$GOAL_FILE"
        echo "Daily calorie goal set to $goal calories."
    else
        echo "Invalid input. Please enter a number."
    fi
}

# add food
add_entry() {
    read -p "Enter food name: " food
    read -p "Enter calories: " calories

    if [[ "$calories" =~ ^[0-9]+$ ]]; then
        echo "$food,$calories" >> "$DATA_FILE"
        echo "$food with $calories calories added."
    else
        echo "Invalid calorie amount."
    fi
}

# all entries
view_entries() {
    if [[ ! -s "$DATA_FILE" ]]; then
        echo "No entries found."
        return
    fi

    echo "Food Entries:"
    echo "----------------------"
    nl -w2 -s'. ' "$DATA_FILE" | while IFS=',' read -r line_num rest; do
        food=$(echo "$rest" | cut -d',' -f1)
        calories=$(echo "$rest" | cut -d',' -f2)
        echo "$line_num $food - $calories calories"
    done
}

# calculate total calories
total_calories() {
    total=$(awk -F',' '{sum += $2} END {print sum+0}' "$DATA_FILE")
    echo "Total calories consumed: $total"
}

# check remaining cals
remaining_calories() {
    if [[ ! -s "$GOAL_FILE" ]]; then
        echo "No calorie goal set yet."
        return
    fi

    goal=$(cat "$GOAL_FILE")
    total=$(awk -F',' '{sum += $2} END {print sum+0}' "$DATA_FILE")
    remaining=$((goal - total))

    echo "Daily goal: $goal"
    echo "Consumed: $total"

    if (( remaining >= 0 )); then
        echo "Remaining calories: $remaining"
    else
        echo "You are over your goal by $((-remaining)) calories."
    fi
}

#  clear all data
clear_data() {
    > "$DATA_FILE"
    echo "All calorie entries cleared."
}

# Main menu
while true; do
    echo
    echo "==== Calorie Tracker ===="
    echo "1. Set daily calorie goal"
    echo "2. Add food entry"
    echo "3. View all entries"
    echo "4. View total calories"
    echo "5. View remaining calories"
    echo "6. Clear all entries"
    echo "7. Exit"
    echo "========================="
    read -p "Choose an option: " choice

    case $choice in
        1) set_goal ;;
        2) add_entry ;;
        3) view_entries ;;
        4) total_calories ;;
        5) remaining_calories ;;
        6) clear_data ;;
        7) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option. Please choose 1-7." ;;
    esac
done