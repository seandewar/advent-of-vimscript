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

func! s:Unmatched(k_into, k) abort
    return a:k->xor(a:k_into)->and(a:k)
endfunc

func! s:P1P2() abort
    const input = readfile('inputs/day8.in')
                \ ->map({_, v -> v->split(' | ')
                \                 ->map({_, v -> v->split()
                \                                 ->map({_, v -> s:Key(v)})})})
    const len2num = #{2: 1, 3: 7, 4: 4, 7: 8}
    let ret = [0, 0]
    for [in_nums, out_nums] in input
        let num2k = {}
        let k2num = {}
        func! s:Store(k, num) closure abort
            let num2k[a:num] = a:k
            let k2num[a:k] = a:num
        endfunc
        for k in in_nums
            let len = s:Len(k)
            if exists('len2num[' .. len .. ']')
                call s:Store(k, len2num[len])
            endif
        endfor
        while len(num2k) < 10
            for k in in_nums
                if exists('k2num[' .. k .. ']') | continue | endif
                if s:Len(k) == 5
                    if s:Unmatched(k, num2k[1]) == 0
                        call s:Store(k, 3)
                    elseif exists('num2k[9]')
                        call s:Store(k, s:Unmatched(k, num2k[9])->s:Len() == 1
                                    \ ? 5 : 2)
                    endif
                else
                    if s:Unmatched(k, num2k[4]) == 0
                        call s:Store(k, 9)
                    elseif exists('num2k[9]')
                        call s:Store(k, s:Unmatched(k, num2k[1]) == 0 ? 0 : 6)
                    endif
                endif
            endfor
        endwhile
        let num = 0
        for k in out_nums
            let num = num * 10 + k2num[k]
            let ret[0] += exists('len2num[' .. s:Len(k) .. ']')
        endfor
        let ret[1] += num
    endfor
    return ret
endfunc

echomsg 'D8:' s:P1P2()
unlet s:masks
