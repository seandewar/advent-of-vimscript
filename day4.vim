func! s:Parse() abort
    const in = readfile('day4.in')
    let ret = #{
                \ nums: in[0]->split(','),
                \ boards: [],
                \ lookup: {},
                \ }
    for line in in[1:]
        if empty(line)
            eval ret.boards->add([])
        else
            let r = line->split()
            let x = 0
            while x < 5
                let ret.lookup[r[x]] = ret.lookup
                            \ ->get(r[x], [])
                            \ ->add([len(ret.boards) - 1, x, len(ret.boards[-1])])
                let x += 1
            endwhile
            eval ret.boards[-1]->add(r)
        endif
    endfor
    return ret
endfunc

func! s:Bingo(board, x, y) abort
    let a:board[a:y][a:x] = -1
    let h_bingo = 1
    let v_bingo = 1
    let i = 0
    while i < 5 && (h_bingo || v_bingo)
        let h_bingo = h_bingo && a:board[a:y][i] == -1
        let v_bingo = v_bingo && a:board[i][a:x] == -1
        let i += 1
    endwhile
    return h_bingo || v_bingo
endfunc

func! s:Sum(board) abort
    let s = 0
    for r in a:board
        for num in r->filter({_, v -> v != -1})
            let s += num
        endfor
    endfor
    return s
endfunc

func! s:P1P2() abort
    let in = s:Parse()
    let bingoed = {}
    let p1 = 0
    for num in in.nums
        for [i, x, y] in in.lookup->get(num, [])
            if !exists('bingoed[i]') && in.boards[i]->s:Bingo(x, y)
                let p1 = empty(bingoed) ? num * s:Sum(in.boards[i]) : p1
                let bingoed[i] = 1
                if len(bingoed) == len(in.boards)
                    return [p1, num * s:Sum(in.boards[i])]
                endif
            endif
        endfor
    endfor
endfunc

echomsg 'D4:' s:P1P2()
