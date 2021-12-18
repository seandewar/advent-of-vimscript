-- this runs in ~1 second on my laptop; the vimscript equivalent takes multiple
-- minutes to run... vimscript is still awesome though, right??????????

local Queue = {}
Queue.__index = Queue
function Queue.new()
  return setmetatable({ l = 1, r = 1 }, Queue)
end
function Queue:len()
  return self.r - self.l
end
function Queue:push(v)
  self[self.r] = v
  self.r = self.r + 1
end
function Queue:pop()
  self.l = self.l + 1
  return self[self.l - 1]
end

local function p1p2()
  local input = {}
  for line in io.lines "inputs/day15.in" do
    local row = {}
    for i = 1, #line do
      row[#row + 1] = line:byte(i) - ("0"):byte()
    end
    input[#input + 1] = row
  end
  local w, h = #input[1], #input
  local min_costs = { 0 }
  for i = 2, w * 5 * h * 5 do
    min_costs[i] = 9999
  end
  local relaxed = Queue.new()
  relaxed:push { 1, 1 }

  local function idx(x, y)
    return w * 5 * (y - 1) + x
  end
  local function relax(x, y, prev_cost)
    if x <= 0 or y <= 0 or x > w * 5 or y > h * 5 then
      return
    end
    local extra = math.floor((y - 1) / h) + math.floor((x - 1) / w)
    local cost = input[(y - 1) % h + 1][(x - 1) % w + 1]
    cost = (cost + extra - 1) % 9 + 1 + prev_cost
    if cost < min_costs[idx(x, y)] then
      min_costs[idx(x, y)] = cost
      if x ~= w * 5 or y ~= h * 5 then
        relaxed:push { x, y }
      end
    end
  end

  while relaxed:len() ~= 0 do
    local x, y = unpack(relaxed:pop())
    local cost = min_costs[idx(x, y)]
    relax(x - 1, y, cost)
    relax(x + 1, y, cost)
    relax(x, y - 1, cost)
    relax(x, y + 1, cost)
  end
  return { min_costs[idx(w, h)], min_costs[#min_costs] }
end

print("D15: " .. vim.inspect(p1p2()))
