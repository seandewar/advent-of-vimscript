func! s:Split(x) abort
    let i = 0
    while i < len(a:x) - 1
        if str2nr(a:x[i]) > 9
            let num = str2nr(a:x[i])
            let a:x[i] = '['
            eval a:x->insert(num / 2, i + 1)
                        \ ->insert(',', i + 2)
                        \ ->insert(num / 2 + num % 2, i + 3)
                        \ ->insert(']', i + 4)
            return 1
        endif
        let i += 1
    endwhile
    return 0
endfunc

func! s:Splash(x, i, step, v) abort
    let i = a:i
    while i >= 0 && i < len(a:x)
        if a:x[i]->match('\d') != -1
            let a:x[i] += a:v
            return
        endif
        let i += a:step
    endwhile
endfunc

func! s:Explode(x) abort
    const len_before = len(a:x)
    let d = -1
    let i = 0
    while i < len(a:x)
        let d += a:x[i] == '['
        let d -= a:x[i] == ']'
        if d == 4
            let pair = a:x[i : i + 4]->join('')->eval()
            eval a:x->s:Splash(i - 1, -1, pair[0])
            eval a:x->s:Splash(i + 5, 1, pair[1])
            eval a:x->remove(i + 1, i + 4)
            let a:x[i] = 0
            let d -= 1
        endif
        let i += 1
    endwhile
    return len(a:x) != len_before
endfunc

func! s:Magnitude(x) abort
    return a:x->join('')
                \ ->substitute('[', '(3*', 'g')
                \ ->substitute(',', '+2*', 'g')
                \ ->substitute(']', ')', 'g')
                \ ->eval()
endfunc

func! s:P1P2() abort
    const input = readfile('inputs/day18.in')
                \ ->map({_, v -> str2list(v)->map({_, v -> nr2char(v)})})
    let num = input[0]
    for x in input[1:]
        let num = ['[']->extend(num)->add(',')->extend(x)->add(']')
        while s:Explode(num) || s:Split(num) | endwhile
    endfor
    let ret = [s:Magnitude(num), 0]
    for x in input
        for y in input
            if x is y | continue | endif
            let num = ['[']->extend(x)->add(',')->extend(y)->add(']')
            while s:Explode(num) || s:Split(num) | endwhile
            let ret[1] = max([ret[1], s:Magnitude(num)])
        endfor
    endfor
    return ret
endfunc

echomsg 'D18:' s:P1P2()
