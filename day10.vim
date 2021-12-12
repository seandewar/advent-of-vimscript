func! s:P1() abort
    const input = readfile('inputs/day10.in')
    const paren_map = {'(': ')', '[': ']', '{': '}', '<': '>'}
    const points_map = {')': 3, ']': 57, '}': 1197, '>': 25137}
    let ret = [0]
    for line in input
        let stack = []
        for cnr in str2list(line)
            let c = nr2char(cnr)
            if exists('points_map[''' .. c .. ''']')
                if stack[-1] != c
                    let ret[0] += points_map[c]
                    break
                endif
                eval stack->remove(-1)
            else
                eval stack->add(paren_map[c])
            endif
        endfor
    endfor
    return ret
endfunc

echomsg 'D10:' s:P1()
