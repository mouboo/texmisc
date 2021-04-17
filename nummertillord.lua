local floor = math.floor
local concat = table.concat

local words = {
               [0] = "noll",
               [1] = "ett",
               [2] = "två",
               [3] = "tre",
               [4] = "fyra",
               [5] = "fem",
               [6] = "sex",
               [7] = "sju",
               [8] = "åtta",
               [9] = "nio",
              [10] = "tio",
              [11] = "elva",
              [12] = "tolv",
              [13] = "tretton",
              [14] = "fjorton",
              [15] = "femton",
              [16] = "sexton",
              [17] = "sjutton",
              [18] = "arton",
              [19] = "nitton",
              [20] = "tjugo",
              [30] = "trettio",
              [40] = "fyrtio",
              [50] = "femtio",
              [60] = "sextio",
              [70] = "sjuttio",
              [80] = "åttio",
              [90] = "nittio",
             [100] = "hundra",
            [10^3] = "tusen",
            [10^6] = "miljon",
            [10^9] = "miljard",
           [10^12] = "biljon",
           [10^15] = "biljard",
}

local function translate(n)
    local t = {}

    if n == 0 then
        return words[0]
    end

    -- group of three digits to words, e.g. 123 -> etthundratjugotre
    local function tripletWords(n)
        local s = ""
        if floor(n/100) > 0 then
            s = s..words[floor(n/100)]..words[100]
        end
        if n%100 > 20 then
            s = s..words[n%100-n%10]
            if n%10 > 0 then
                s = s..words[n%10]
            end
        elseif n%100 > 0 then
            s = s..words[n%100]
        end
        return s
    end
    
    -- loops through 10^15,10^12,...10^3, extracting groups of three digits
    -- to make words from, then adding names for order of magnitude
    for i=15,3,-3 do
        local triplet = floor(n/10^i)%10^3
        if triplet > 0 then
            -- grammar: "en" instead of "ett"
            if i > 3 and triplet == 1 then
                t[#t+1] = "en"
            else
                t[#t+1] = tripletWords(triplet)
            end
            -- grammar: plural form of "millions" etc
            if i > 3 and triplet > 1 then
                t[#t+1] = words[10^i].."er"
            else
                t[#t+1] = words[10^i]
            end
        end
    end
    
    -- add last group of three numbers (no word for magnitude)
    if n%1000 > 0 then
        t[#t+1] = tripletWords(n%1000)
    end
    
    local s = concat(t," ")
    -- grammar: spacing for numbers < 10^6 and repeated letters
    if n < 10^6 then
        s = s:gsub("%stusen%s","tusen")
        s = s:gsub("etttusen","ettusen")
    end
    
    return s
end

print(translate(tonumber(arg[1])))
