const s:in = readfile('day2.in')
            \ ->map({_, v -> split(v)})
            \ ->map({_, v -> [v[0][0], str2nr(v[1])]})

func! s:P1() abort
    let d = 0
    let x = 0
    for ins in s:in
        if ins[0] ==# 'f'
            let x += ins[1]
        else
            let d += ins[0] ==# 'd' ? ins[1] : -ins[1]
        endif
    endfor
    return d * x
endfunc

func! s:P2() abort
    let d = 0
    let x = 0
    let a = 0
    for ins in s:in
        if ins[0] ==# 'f'
            let x += ins[1]
            let d += a * ins[1]
        else
            let a += ins[0] ==# 'd' ? ins[1] : -ins[1]
        endif
    endfor
    return d * x
endfunc

echomsg "D2 P1:" s:P1() "P2:" s:P2()
unlet s:in
