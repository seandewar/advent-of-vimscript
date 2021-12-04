func! s:P1P2() abort
    const in = readfile('day2.in')
                \ ->map({_, v -> split(v)})
                \ ->map({_, v -> [v[0][0], str2nr(v[1])]})
    let d = [0, 0]
    let x = 0
    let a = 0
    for ins in in
        if ins[0] ==# 'f'
            let x += ins[1]
            let d[1] += a * ins[1]
        else
            let a += ins[0] ==# 'd' ? ins[1] : -ins[1]
            let d[0] += ins[0] ==# 'd' ? ins[1] : -ins[1]
        endif
    endfor
    return [d[0] * x, d[1] * x]
endfunc

echomsg 'D2:' s:P1P2()
