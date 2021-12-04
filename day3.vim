func! s:NetCount(in, i) abort
    let count = 0
    for v in a:in
        let count += v[a:i] == '1' ? 1 : -1
    endfor
    return count
endfunc

func! s:Rating(in, cond) abort
    let rem = copy(a:in)
    let i = 0
    while len(rem) > 1
        let count = rem->s:NetCount(i)
        eval rem->filter({_, v -> v[i] == a:cond(count) ? '1' : '0'})
        let i += 1
    endwhile
    return str2nr(rem[0], 2)
endfunc

func! s:P1P2() abort
    const in = readfile('day3.in')
    const bits = [0]
                \ ->repeat(12)
                \ ->map({i, _ -> in->s:NetCount(i) > 0 ? '1' : '0'})
                \ ->join('')
    const g = str2nr(bits, 2)
    const e = g->invert()->and(0b111111111111)
    return [g * e, in->s:Rating({v -> v >= 0}) * in->s:Rating({v -> v < 0})]
endfunc

echomsg 'D3:' s:P1P2()
