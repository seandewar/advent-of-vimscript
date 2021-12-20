func! s:Fold(list, func, init) abort
    let ret = a:init
    for v in a:list
        let ret = a:func(ret, v)
    endfor
    return ret
endfunc

const s:type2op = #{
            \ 0: {v -> s:Fold(v, {a, x -> a + x}, 0)},
            \ 1: {v -> s:Fold(v, {a, x -> a * x}, 1)},
            \ 2: function('min'),
            \ 3: function('max'),
            \ 5: {v -> v[0] > v[1]},
            \ 6: {v -> v[0] < v[1]},
            \ 7: {v -> v[0] == v[1]},
            \ }

func! s:Decode(in, i) abort
    let version_sum = a:in[a:i : a:i + 2]->str2nr(2)
    const type = a:in[a:i + 3 : a:i + 5]->str2nr(2)
    let value = 0
    let i = a:i + 6
    if type == 4  " literal value
        while 1
            let value = value * 0x10 + a:in[i + 1 : i + 4]->str2nr(2)
            let i += 5
            if !a:in[i - 5] | break | endif
        endwhile
    else  " operator
        let values = []
        const count_subs = a:in[i]
        const len_len = count_subs ? 11 : 15
        let len = a:in[i + 1 : i + len_len]->str2nr(2)
        let i += 1 + len_len
        while len > 0
            let result = s:Decode(a:in, i)
            let version_sum += result[0]
            eval values->add(result[1])
            let len -= count_subs ? 1 : result[2]
            let i += result[2]
        endwhile
        let value = s:type2op[type](values)
    endif
    return [version_sum, value, i - a:i]
endfunc

func! s:P1P2() abort
    const input = readfile('inputs/day16.in')[0]->str2list()
                \ ->map({_, v -> str2nr(nr2char(v), 16)->printf('%04b')})
                \ ->join('')
    return s:Decode(input, 0)[0:1]
endfunc

echomsg 'D16:' s:P1P2()
