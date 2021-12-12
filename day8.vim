const s:masks = [1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200]

func! s:Key(s) abort
    let key = 0
    for c in str2list(a:s)
        let key += s:masks[c - char2nr('a')]
    endfor
    return key
endfunc

func! s:Len(k) abort
    let len = 0
    for m in s:masks
        let len += a:k->and(m) != 0
    endfor
    return len
endfunc

func! s:P1P2() abort
    const input = readfile('inputs/day8.in')
                \ ->map({_, v -> v->split(' | ')
                \                 ->map({_, v -> v->split()
                \                                 ->map({_, v -> s:Key(v)})})})
    const len1478 = #{2: 1, 3: 7, 4: 4, 7: 8}
    const len5tab = [[[1, 2], 2], [[2, 3], 3], [[1, 3], 5]]
    const len6tab = [[[2, 3], 0], [[1, 3], 6], [[2, 4], 9]]
    let ret = [0, 0]
    for [in_nums, out_nums] in input
        let k2num = {}
        let k14 = [0, 0]
        for k in in_nums
            let len = s:Len(k)
            if exists('len1478[' .. len .. ']')
                let num = len1478[len]
                let k2num[k] = num
                if num == 1 || num == 4 | let k14[num == 4] = k | endif
            endif
        endfor
        for k in in_nums
            if exists('k2num[' .. k .. ']') | continue | endif
            let m14 = copy(k14)->map({_, v -> v->and(k)->s:Len()})
            for [num_m14, num] in s:Len(k) == 5 ? len5tab : len6tab
                if m14 == num_m14
                    let k2num[k] = num
                    break
                endif
            endfor
        endfor
        let out_num = 0
        for k in out_nums
            let out_num = out_num * 10 + k2num[k]
            let ret[0] += exists('len1478[' .. s:Len(k) .. ']')
        endfor
        let ret[1] += out_num
    endfor
    return ret
endfunc

echomsg 'D8:' s:P1P2()
