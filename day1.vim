func! s:P1P2() abort
    const in = readfile('day1.in')->map({_, v -> str2nr(v)})
    let ret = [0, 0]
    let i = 1
    while i < len(in)
        let ret[0] += in[i] > in[i - 1] ? 1 : 0
        if i > 2
            let s1 = in[i] + in[i - 1] + in[i - 2]
            let s2 = in[i - 1] + in[i - 2] + in[i - 3]
            let ret[1] += s1 > s2 ? 1 : 0
        endif
        let i += 1
    endwhile
    return ret
endfunc

echomsg 'D1:' s:P1P2()
