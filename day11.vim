func! s:Flash(in, x, y) abort
    let a:in[a:y][a:x] = -1
    let y2 = max([0, a:y - 1])
    while y2 < min([10, a:y + 2])
        let x2 = max([0, a:x - 1])
        while x2 < min([10, a:x + 2])
            let a:in[y2][x2] += a:in[y2][x2] != -1
            let x2 += 1
        endwhile
        let y2 += 1
    endwhile
endfunc

func! s:P1P2() abort
    let input = readfile('inputs/day11.in')
                \ ->map({_, v -> str2list(v)->map({_, v -> nr2char(v)})})
    let ret = [0, 0]
    while 1
        eval input->map({_, r -> r->map({_, v -> max([0, v]) + 1})})
        let flashes = 0
        while 1
            let before = flashes
            let y = 0
            while y < 10
                let x = 0
                while x < 10
                    if input[y][x] > 9
                        call s:Flash(input, x, y)
                        let flashes += 1
                    endif
                    let x += 1
                endwhile
                let y += 1
            endwhile
            if flashes == before | break | endif
        endwhile
        let ret[0] += ret[1] < 100 ? flashes : 0
        let ret[1] += 1
        if flashes == 100 | return ret | endif
    endwhile
endfunc

echomsg 'D11:' s:P1P2()
