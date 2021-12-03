const s:in = readfile('day3.in')

func! s:P1() abort
    let counts = [0]->repeat(12)
    for v in s:in
        let i = 0
        while i < 12
            let counts[i] += v[i] ==# '1' ? 1 : -1
            let i += 1
        endwhile
    endfor
    let gamma = str2nr(counts->map({_, v -> v > 0 ? '1' : '0'})->join(''), 2)
    let epsilon = gamma->invert()->and(0b111111111111)
    return gamma * epsilon
endfunc

echomsg "D3 P1:" s:P1()
unlet s:in
