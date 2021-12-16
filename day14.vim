func! s:Parse() abort
    const input = readfile('inputs/day14.in')
    let ret = #{tp_counts: {}, rules: {}}
    let i = 0
    while i < len(input[0]) - 1
        let k = input[0][i : i + 1]
        let ret.tp_counts[k] = ret.tp_counts->get(k, 0) + 1
        let i += 1
    endwhile
    let ret.tp_end = input[0][len(input[0]) - 1]
    for [k, v] in input[2:]->map({_, v -> v->split(' -> ')})
        let ret.rules[k] = v
    endfor
    return ret
endfunc

func! s:P1P2() abort
    let input = s:Parse()

    func! s:Score() closure abort
        let ch_counts = {}
        for [k, v] in items(input.tp_counts)
            let ch_counts[k[0]] = ch_counts->get(k[0], 0) + v
            let ch_counts[k[1]] = ch_counts->get(k[1], 0) + v
        endfor
        let ch_counts[input.tp_end] = ch_counts->get(input.tp_end, 0) + 1
        const real_counts = values(ch_counts)->map({_, v -> v / 2})
        return max(real_counts) - min(real_counts)
    endfunc

    let ret_p1 = 0
    let i = 0
    while i < 40
        for [k, v] in items(input.tp_counts)
            let newk = [k[0] .. input.rules[k], input.rules[k] .. k[1]]
            let input.tp_counts[newk[0]] = input.tp_counts->get(newk[0], 0) + v
            let input.tp_counts[newk[1]] = input.tp_counts->get(newk[1], 0) + v
            let input.tp_counts[k] -= v
        endfor
        let ret_p1 = i == 9 ? s:Score() : ret_p1
        let i += 1
    endwhile
    return [ret_p1, s:Score()]
endfunc

echomsg 'D14:' s:P1P2()
