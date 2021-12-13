func! s:Dfs(adj_map, out, visits, node) abort
    const can_visit_x2 = a:visits->values()->count(2) == 0
    if a:visits->get(a:node, 0) > (a:node == 'start' ? 0 : can_visit_x2)
        return
    endif
    if a:node == 'end'
        let a:out[0] += can_visit_x2
        let a:out[1] += 1
        return
    elseif a:node->match('\U') != -1
        let a:visits[a:node] = a:visits->get(a:node, 0) + 1
    endif
    for to in a:adj_map->get(a:node, [])
        call s:Dfs(a:adj_map, a:out, a:visits, to)
    endfor
    if exists('a:visits[''' .. a:node .. ''']')
        let a:visits[a:node] -= 1  " back-track!
    endif
endfunc

func! s:P1P2() abort
    const input = readfile('inputs/day12.in')->map({_, v -> v->split('-')})
    let adj_map = {}
    for [a, b] in input
        let adj_map[a] = adj_map->get(a, [])->add(b)
        let adj_map[b] = adj_map->get(b, [])->add(a)
    endfor
    let ret = [0, 0]
    call s:Dfs(adj_map, ret, {}, 'start')
    return ret
endfunc

echomsg 'D12:' s:P1P2() | " NOTE: vimscript slowwwwwww
