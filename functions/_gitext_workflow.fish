function _gitext_workflow
    set action $argv[1]
    set source $argv[2]
    set destination $argv[3]

    set branch (git rev-parse --abbrev-ref HEAD)

    if test $status -ne 0
        return 1
    end

    if test "$branch" != "$source"
        echo "# ERROR:"
        echo "$action is not allowed for branch '$branch'."
        echo "You must be on branch '$source'."
        return 1
    end

    git checkout $destination
    git merge $source
    git push
    git checkout $source
end
