func! s:Key2Pos(k) abort
    return a:k->split(',')->map({_, v -> str2nr(v)})
endfunc

func! s:Parse() abort
    const input = readfile('inputs/day13.in')
    let ret = #{dots: {}, size: [0, 0], folds: []}
    let i = 0
    while !empty(input[i])
        let ret.dots[input[i]] = 1
        let xy = s:Key2Pos(input[i])
        eval ret.size->map({i, v -> max([v, xy[i] + 1])})
        let i += 1
    endwhile
    for line in input[i + 1:]
        eval ret.folds->add(line->matchlist('\(\w\)=\(\d\+\)')[1:2])
    endfor
    return ret
endfunc

func! s:P1P2() abort
    let input = s:Parse()
    let ret = [-1, -1]
    for [axis, pos] in input.folds
        let i = axis == 'y'
        let input.size[i] = pos
        for k in keys(input.dots)
            let xy = s:Key2Pos(k)
            if xy[i] > pos
                eval input.dots->remove(k)
                eval xy->map({j, v -> i == j ? 2 * pos - v : v})
                let input.dots[xy->join(',')] = 1
            endif
        endfor
        let ret[0] = ret[0] == -1 ? len(input.dots) : ret[0]
    endfor
    let ret[1] = [0]->repeat(input.size[1])
                \   ->map({-> [' ']->repeat(input.size[0])})
    for k in keys(input.dots)
        let xy = s:Key2Pos(k)
        let ret[1][xy[1]][xy[0]] = '#'
    endfor
    return [ret[0], ret[1]->map({_, v -> v->join('')})]
endfunc

let s:result = s:P1P2()
echomsg 'D13:' s:result[0]
for line in s:result[1] | echomsg line | endfor
