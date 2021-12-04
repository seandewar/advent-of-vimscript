const s:in = readfile('day3.in')

func! s:NetCount(in, i) abort
    let count = 0
    for v in a:in
        let count += v[a:i] == '1' ? 1 : -1
    endfor
    return count
endfunc

func! s:P1() abort
    const bits = [0]
                \ ->repeat(12)
                \ ->map({i, _ -> s:in->s:NetCount(i) > 0 ? '1' : '0'})
                \ ->join('')
    const gamma = str2nr(bits, 2)
    const epsilon = gamma->invert()->and(0b111111111111)
    return gamma * epsilon
endfunc

func! s:Rating(cond) abort
    let rem = copy(s:in)
    let i = 0
    while len(rem) > 1
        let count = rem->s:NetCount(i)
        eval rem->filter({_, v -> v[i] == (a:cond(count) ? '1' : '0')})
        let i += 1
    endwhile
    return str2nr(rem[0], 2)
endfunc

func! s:P2() abort
    return s:Rating({v -> v >= 0}) * s:Rating({v -> v < 0})
endfunc

echomsg "D3 P1:" s:P1() "P2:" s:P2()
unlet s:in
