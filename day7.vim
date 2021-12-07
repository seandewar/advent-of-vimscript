func! s:P1P2() abort
    const input = readfile('inputs/day7.in')[0]->split(',')
    const max = input->max()
    let ret = [v:numbermax, v:numbermax]
    let x = 0
    while x <= max
        let total = [0, 0]
        for v in input
            let d = abs(v - x)
            let total[0] += d
            let total[1] += (d * (d + 1)) / 2
        endfor
        eval ret->map({i, v -> total[i] < v ? total[i] : v})
        let x += 1
    endwhile
    return ret
endfunc

echomsg 'D7:' s:P1P2()
