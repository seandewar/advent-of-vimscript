func! s:P1P2() abort
    const input = readfile('inputs/day1.in')->map({_, v -> str2nr(v)})
    let ret = [0, 0]
    let i = 1
    while i < len(input)
        let ret[0] += input[i] > input[i - 1] ? 1 : 0
        if i > 2
            let s1 = input[i] + input[i - 1] + input[i - 2]
            let s2 = input[i - 1] + input[i - 2] + input[i - 3]
            let ret[1] += s1 > s2 ? 1 : 0
        endif
        let i += 1
    endwhile
    return ret
endfunc

echomsg 'D1:' s:P1P2()
