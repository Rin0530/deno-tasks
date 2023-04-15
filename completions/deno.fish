function __fish_deno_task
    set -l deno_json (ls | grep -E deno.jsonc\?)
    if string length -q -- $deno_json
        deno eval '
            const decoder = new TextDecoder();
            for await (const chunk of Deno.stdin.readable) {
                const text = decoder.decode(chunk);
                const json = JSON.parse(text)
                for(const task in json.tasks){
                    console.log(`${task}\t${json.tasks[task].substring(0,18)}`)
                }
            }
        '<$deno_json 2>/dev/null
    end
end

deno completions fish | source
complete -c deno -f -n "__fish_seen_subcommand_from task" -a '(__fish_deno_task)' -d "task list"