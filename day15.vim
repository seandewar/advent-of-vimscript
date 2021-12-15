func! s:P1P2() abort
    const input = readfile('inputs/day15.in')
                \ ->map({_, v -> str2list(v)
                \                ->map({_, v -> str2nr(nr2char(v))})})
    const w = len(input[0]) | const h = len(input)
    let min_costs = [0]->repeat(h * 5)->map({-> [v:numbermax]->repeat(w * 5)})
    let min_costs[0][0] = 0
    let relaxed = [[0, 0]]

    func! s:TryRelax(x, y, prev_cost) closure abort
        if a:x < 0 || a:y < 0 || a:x >= w * 5 || a:y >= h * 5 | return | endif
        let cost = (input[a:y % h][a:x % w] + a:y / h + a:x / w - 1) % 9 + 1
        let cost += a:prev_cost
        if cost < min_costs[a:y][a:x]
            let min_costs[a:y][a:x] = cost
            if x != w * 5 - 1 || y != h * 5 - 1
                eval relaxed->add([a:x, a:y])
            endif
        endif
    endfunc

    while !empty(relaxed)
        let path = relaxed->remove(0)
        let x = path[0] | let y = path[1]
        call s:TryRelax(x - 1, y, min_costs[y][x])
        call s:TryRelax(x + 1, y, min_costs[y][x])
        call s:TryRelax(x, y - 1, min_costs[y][x])
        call s:TryRelax(x, y + 1, min_costs[y][x])
    endwhile
    return [min_costs[h - 1][w - 1], min_costs[h * 5 - 1][w * 5 - 1]]
endfunc

echomsg 'D15:' s:P1P2() | " NOTE: vimscript REALLY SLOOOOOOOOOOOOOOW
