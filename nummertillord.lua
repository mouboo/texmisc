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
}

local function translate(n)
    local t = {}

    if n == 0 then 
        return words[0] 
    end

    -- Deal with numbers bigger than 999999.
    for _, bignum in ipairs({10^12,10^9,10^6}) do
        if floor(n/bignum) > 0 then 
            t[#t+1] = translate(floor(n/bignum))
            -- For millions (and bigger) "1" is "en", not "ett", 
            if t[#t] == words[1] then
                t[#t] = "en"
            end
            t[#t+1] = words[bignum]
            -- and plural form ending with "-er"
            if floor(n/bignum) > 1 then
                t[#t] = t[#t].."er"
            end
            n = n % bignum
        end 
    end
    
    -- Deal with 1000s
    if floor(n/1000) > 0 then 
        t[#t+1] = translate(floor(n/1000))
        t[#t+1] = words[1000]
        n = n % 1000
    end
    
    -- Deal with 100s
    if floor(n/100) > 0 then 
        t[#t+1] = translate(floor(n/100))
        t[#t+1] = words[100]
        n = n % 100
    end    
    
    -- Deal with <100s
    if n > 0 then
        if n < 20 then
            t[#t+1] = words[n]
        else
            t[#t+1] = words[floor(n-n%10)]
            if n%10 > 0 then
                t[#t+1] = words[n%10]
            end
        end
    end
        
    -- Add spaces. "Million" and larger always get spaces,
    -- "thousand" get spaces if the original number is
    -- larger than 999999
    -- TODO
  
    return concat(t,"")
end

print(translate(tonumber(arg[1])))
