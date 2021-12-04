func! s:Parse() abort
    const in = readfile('day4.in')
    let ret = #{
                \ nums: in[0]->split(',')->map({_, v -> str2nr(v)}),
                \ boards: [],
                \ lookup: {},
                \ }
    for line in in[1:]
        if empty(line)
            eval ret.boards->add([])
        else
            let r = line->split()->map({_, v -> str2nr(v)})
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
const s:in = s:Parse()

func! s:Bingo(board, x, y) abort
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
        for num in r->filter({_, v -> v != -1 })
            let s += num
        endfor
    endfor
    return s
endfunc

func! s:P1() abort
    let boards = deepcopy(s:in.boards)
    for num in s:in.nums
        for [i, x, y] in s:in.lookup->get(num, [])
            let b = boards[i]
            let b[y][x] = -1
            if b->s:Bingo(x, y)
                return num * s:Sum(b)
            endif
        endfor
    endfor
endfunc

echomsg 'D4 P1:' s:P1()
unlet s:in
