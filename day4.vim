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

func! s:P1() abort
    let boards = deepcopy(s:in.boards)
    for num in s:in.nums
        for [i, x, y] in s:in.lookup->get(num, [])
            if boards[i]->s:Bingo(x, y)
                return num * s:Sum(boards[i])
            endif
        endfor
    endfor
endfunc

func! s:P2() abort
    let boards = deepcopy(s:in.boards)
    let bingoed = {}
    for num in s:in.nums
        for [i, x, y] in s:in.lookup->get(num, [])
            if !exists('bingoed[i]') && boards[i]->s:Bingo(x, y)
                let bingoed[i] = 1
                if len(bingoed) == len(boards)
                    return num * s:Sum(boards[i])
                endif
            endif
        endfor
    endfor
endfunc

echomsg 'D4 P1:' s:P1() 'P2:' s:P2()
unlet s:in
