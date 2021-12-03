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

echomsg "D2 P1:" s:P1()
unlet s:in
