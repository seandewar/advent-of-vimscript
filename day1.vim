const s:in = readfile('day1.in')->map({_, v -> str2nr(v)})

func! s:P1() abort
    let ret = 0
    let i = 1
    while i < len(s:in)
        if s:in[i] > s:in[i - 1]
            let ret += 1
        endif
        let i += 1
    endwhile
    return ret
endfunc

func! s:P2() abort
    let ret = 0
    let i = 3
    while i < len(s:in)
        let s1 = s:in[i] + s:in[i - 1] + s:in[i - 2]
        let s2 = s:in[i - 1] + s:in[i - 2] + s:in[i - 3]
        if s1 > s2
            let ret += 1
        endif
        let i += 1
    endwhile
    return ret
endfunc

echomsg "D1 P1:" s:P1() "P2:" s:P2()
unlet s:in
