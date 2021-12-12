func! s:Low(in, x, y) abort
    const val = a:in[a:y][a:x]
    return (a:x == 0 || a:in[a:y][a:x - 1] > val)
                \ && (a:y == 0 || a:in[a:y - 1][a:x] > val)
                \ && a:in[a:y]->get(a:x + 1, -1) > val
                \ && a:in->get(a:y + 1, [])->get(a:x, -1) > val
endfunc

func! s:Fill(in, x, y) abort
    if a:x < 0 || a:y < 0 || a:in->get(a:y, [])->get(a:x, 9) == 9
        return 0
    endif
    let a:in[a:y][a:x] = 9
    return 1 + s:Fill(a:in, a:x - 1, a:y) + s:Fill(a:in, a:x + 1, a:y)
                \ + s:Fill(a:in, a:x, a:y - 1) + s:Fill(a:in, a:x, a:y + 1)
endfunc

func! s:P1P2() abort
    let input = readfile('inputs/day9.in')
                \ ->flatten()
                \ ->map({_, v -> str2list(v)->map({_, v -> nr2char(v)})})
    let ret = [0, [0, 0, 0]]
    let lows = []
    let y = 0
    while y < len(input)
        let x = 0
        while x < len(input[0])
            if s:Low(input, x, y)
                eval lows->add([x, y])
                let ret[0] += input[y][x] + 1
            endif
            let x += 1
        endwhile
        let y += 1
    endwhile
    for [x, y] in lows
        eval ret[1]->add(s:Fill(input, x, y))->sort({a, b -> b - a})->remove(-1)
    endfor
    return [ret[0], ret[1][0] * ret[1][1] * ret[1][2]]
endfunc

echomsg 'D9:' s:P1P2()
