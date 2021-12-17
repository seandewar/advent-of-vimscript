func! s:Decode(input, i) abort
    let packets = [{}]
    let packet = packets[0]
    let packet.version = a:input[a:i : a:i + 2]->str2nr(2)
    let packet.type = a:input[a:i + 3 : a:i + 5]->str2nr(2)
    let i = a:i + 6
    if packet.type == 4  " literal value
        let packet.value = 0
        while 1
            let packet.value *= 0b10000
            let packet.value += a:input[i + 1 : i + 4]->str2nr(2)
            let i += 5
            if !a:input[i - 5] | break | endif
        endwhile
    else  " operator
        let i += 1
        let count_subpackets = a:input[i - 1]
        let len_bitcount = count_subpackets ? 11 : 15
        let len = a:input[i : i + len_bitcount - 1]->str2nr(2)
        let i += len_bitcount
        while len > 0
            let result = s:Decode(a:input, i)
            eval packets->extend(result[0])
            let i += result[1]
            let len -= count_subpackets ? 1 : result[1]
        endwhile
    endif
    return [packets, i - a:i]
endfunc

func! s:P1P2() abort
    const input = readfile('inputs/day16.in')[0]->str2list()
                \ ->map({_, v -> str2nr(nr2char(v), 16)->printf('%04b')})
                \ ->join('')
    const decoded = s:Decode(input, 0)
    let ret = [0, 0]
    for packet in decoded[0]
        let ret[0] += packet.version
    endfor
    return ret
endfunc

echomsg 'D16:' s:P1P2()
