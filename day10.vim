func! s:P1P2() abort
    const input = readfile('inputs/day10.in')
    const parens = {'(': ')', '[': ']', '{': '}', '<': '>'}
    const corrupt_scores = {')': 3, ']': 57, '}': 1197, '>': 25137}
    const incomplete_scores = {')': 1, ']': 2, '}': 3, '>': 4}
    let ret = [0, []]
    for line in input
        let stack = []
        for cnr in str2list(line)
            let c = nr2char(cnr)
            if exists('corrupt_scores[''' .. c .. ''']')
                if stack[-1] != c
                    let ret[0] += corrupt_scores[c]
                    let stack = []
                    break
                endif
                eval stack->remove(-1)
            else
                eval stack->add(parens[c])
            endif
        endfor
        if !empty(stack)
            eval ret[1]->add(0)
            for c in reverse(stack)
                let ret[1][-1] = ret[1][-1] * 5 + incomplete_scores[c]
            endfor
        endif
    endfor
    return [ret[0], ret[1]->sort('n')[len(ret[1]) / 2]]
endfunc

echomsg 'D10:' s:P1P2()
