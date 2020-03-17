function gitext_add \
    --description "Interactively add modified files to the staging area in the current git repository"

    if ! set files (git status --short)
        return 1
    end

    if test (count $files) -lt 1
        echo "No files to add."
        return 0
    end

    set file_id 0
    for entry in $files
        set file_id (math $file_id + 1)
        set entry (string split -n -m 1 " " (string trim "$entry"))
        set filename (string trim "$entry[2]")
        set filenames_list $filenames_list "$filename"

        echo "$file_id: $filename ($entry[1])"
    end

    read -P "Add file(s): " id_list_expr
    if test $id_list_expr = "q" -o -z $id_list_expr
        return 0
    else if test $id_list_expr = "a"
        set target_id_list (seq (count $filenames_list))
    else if ! string match -rq '^(\\d+(-\\d+)? ?)+$' "$id_list_expr"
        echo "ERROR: Invalid ID list."
        return 1
    else
        set id_list (string split -n " " "$id_list_expr")
        for id_expr in $id_list
            if set range (string split -m 1 "-" "$id_expr")
                if test (count $range) -gt 2
                    echo "ERROR: Invalid ID range: $id_expr."
                    return 1
                else
                    for id in (seq $range[1] $range[2])
                        set target_id_list $target_id_list $id
                    end
                end
            else
                set target_id_list $target_id_list $id_expr
            end
        end
    end

    for target_id in $target_id_list
        set target_file "$filenames_list[$target_id]"
        if test -z "$target_file"
            echo "WARNING: No file with ID $target_id"
        else
            echo "Adding file: $target_file"
            git add "$target_file"
        end
    end

end
