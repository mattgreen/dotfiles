function __j_completions
    set path ~/Projects/
    if test (count $argv) -ge 1
        set path ~/Projects/$argv[1]
    end

    eval "set dirs "$path"*/"

    if test $dirs[1]
		printf "%s\n" $dirs | sed 's/\/Users\/matt\/Projects\///'
	end
end

