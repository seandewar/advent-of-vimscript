func! s:P1P2() abort
    let timers = [0]->repeat(9)
    let counts = [0, 0]
    for v in readfile('day6.in')[0]->split(',')
        let timers[v] += 1
        let counts[0] += 1
    endfor
    let i = 0
    while i < 256
        let timers[(i + 7) % 9] += timers[i % 9]
        let counts[i < 80 ? 0 : 1] += timers[i % 9]
        let i += 1
    endwhile
    return [counts[0], counts[0] + counts[1]]
endfunc

echomsg 'D6:' s:P1P2()
