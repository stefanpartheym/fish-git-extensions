function gitext_checkout \
    --description "Interactively checkout a branch in the current git repository"

    set branches (git branch)
    if test (count $branches) -lt 2
        echo "ERROR: No branches available for checkout."
        return 1
    end

    for branch in $branches
        if test (string sub --length 1 "$branch") != "*"
            set branch_list $branch_list (string sub -s 3 "$branch")
        end
    end

    set branch_id 0
    for branch_name in $branch_list
        set branch_id (math $branch_id + 1)
        echo "$branch_id: $branch_name"
    end

    while true
        read -P "Switch to branch (enter 'q' to quit): " target_id
        if test "$target_id" = "q"
            break
        else if string match --quiet --regex '\d' "$target_id" && test $target_id -ge 1 -a $target_id -le (count $branch_list)
            git checkout $branch_list[$target_id]
            break
        else
            echo "ERROR: Input '$target_id' is not valid"
        end
    end

end
