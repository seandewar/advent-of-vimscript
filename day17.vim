" Part 1 probably needs some explanation:
"
" We really need only think about the y velocity (vy) of the drone.
"
" Also, the larger vy is when inside the target zone (in the negative direction,
" of course), the larger vy was when the drone was launched. To reach the best
" peak y, initial vy, and thus, vy inside the target zone, must be as large as
" possible without overshooting the target zone. Ideally, abs(vy) must be equal
" to the absolute y coordinate of the target zone (abs(zy)), minus one (which is
" needed or we'd overshoot due to the order of effects during a step; our vy is
" actually one less than what our initial vy (negated) was).
"
" Given the rules, we know that the value of vy decrements each step due to
" gravity. We also know that at peak y, vy must be 0. So, vy at y = 0 must be
" equal to negative initial vy, minus one. From this, we can simply calculate
" the distance the drone would travel during the steps that would bring its
" abs(vy) from 0 to (abs(zy) - 1): 1 + 2 + ... + (abs(zy) - 2) + (abs(zy) - 1).
"
" As a formula, this is: n * (n + 1) / 2 => (abs(zy) - 1) * abs(zy) / 2
" We know zy is negative, so this can be written as: (zy + 1) * zy / 2
"
" Note that this assumes x is far away enough that we can ignore it (there
" should hopefully be a value of x that works given the previous conditions).
"
" As for Part 2, I just brute-forced it... It's simple enough!

func! s:P1P2() abort
    const input = readfile('inputs/day17.in')[0]
                \ ->matchlist('x=\([-0-9]\+\)\.\.\([-0-9]\+\), ' ..
                \             'y=\([-0-9]\+\)\.\.\([-0-9]\+\)$')[1:4]
    const xs = input[:1] | const ys = input[2:]
    let count = 0
    let init_vx = 1
    while init_vx <= xs[1]
        let init_vy = ys[0]
        while init_vy <= abs(ys[0])
            let v = [init_vx, init_vy]
            let p = [0, 0]
            while p[0] <= xs[1] && p[1] >= ys[0] && (v[0] > 0 || p[0] >= xs[0])
                if p[0] >= xs[0] && p[0] <= xs[1]
                            \ && p[1] >= ys[0] && p[1] <= ys[1]
                    let count += 1
                    break
                endif
                eval p->map({i, a -> a + v[i]})
                let v[0] = max([0, abs(v[0]) - 1]) * (v[0] < 0 ? -1 : 1)
                let v[1] -= 1
            endwhile
            let init_vy += 1
        endwhile
        let init_vx += 1
    endwhile
    return [(ys[0] + 1) * ys[0] / 2, count]
endfunc

echomsg 'D17:' s:P1P2()
