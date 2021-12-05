func! s:Plot(lookup, k) abort
    let a:lookup[a:k] = a:lookup->get(a:k, 0) + 1
    return a:lookup[a:k] == 2
endfunc

func! s:P1P2() abort
    const input = readfile('day5.in')
                \ ->map({_, v -> v->split(' -> ')
                \                 ->map({_, v -> v->split(',')
                \                                 ->map({_, v -> str2nr(v)})})})
    let lookup = [{}, {}]
    let ret = [0, 0]
    for [a, b] in input
        let dxy = copy(b)->map({i, v -> v == a[i] ? 0 : v > a[i] ? 1 : -1})
        let xy = copy(a)
        let straight = dxy[0] == 0 || dxy[1] == 0
        while 1
            let k = xy->join(',')
            let ret[0] += straight && s:Plot(lookup[0], k) ? 1 : 0
            let ret[1] += s:Plot(lookup[1], k) ? 1 : 0
            if xy == b | break | endif
            eval xy->map({i, v -> v + dxy[i]})
        endwhile
    endfor
    return ret
endfunc

echomsg 'D5:' s:P1P2() | " NOTE: this takes ~24 seconds to run on my laptop
