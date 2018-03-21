function num2word(sum)
    local zero = "ноль"
    local ones = {
        "один",
        "два",
        "три",
        "четыре",
        "пять",
        "шесть",
        "семь",
        "восемь",
        "девять",
        "десять",
        "одиннадцать",
        "двенадцать",
        "тринадцать",
        "четырнадцать",
        "пятнадцать",
        "шестнадцать",
        "семнадцать",
        "восемнадцать",
        "девятнадцать"
    }
    local tens = {
        "",
        "двадцать",
        "тридцать",
        "сорок",
        "пятьдесят",
        "шестьдесят",
        "семьдесят",
        "восемьдесят",
        "девяносто"
    }
    local hundreds = {
        "сто",
        "двести",
        "триста",
        "четыреста",
        "пятьсот",
        "шестьсот",
        "семьсот",
        "восемьсот",
        "девятьсот"
    }
    local unitsPlural = {
        {"", "", ""},
        {"тысяча", "тысячи", "тысяч"},
        {"миллион", "миллиона", "миллионов"},
        {"миллиард", "миллиарда", "миллиардов"},
        {"триллион", "триллиона", "триллионов"}
    }
    local integersPlural = {"рубль", "рубля", "рублей"}
    local decimalsPlural = {"копейка", "копейки", "копеек"}

    local out       = ""
    local triplePos = 0
    local formatted = string.format("%.2f", sum)
    local number    = math.floor(tonumber(formatted), 10)
    local decimal   = formatted:match("%.(%d+)")

    function plural(n, titles)
        local cases = {3, 1, 2, 2, 2, 3}
        local index = 0

        if (n % 100 > 4 and n % 100 < 20) then
            index = 3
        else
            index = cases[math.min(n % 10, 5) + 1]
        end
        return titles[index]
    end

    function trim(s)
        return s:gsub("^%s*(.-)%s*$", "%1")
    end

    while (number > 0) do
        local tripleStr  = ""
        local tripleUnit = ""
        local triple     = number % 1000

        number    = math.floor(number / 1000)
        triplePos = triplePos + 1

        if (triplePos > 5) then
            return ""
        end

        if (triple > 0) then
            local unitPlural = unitsPlural[triplePos]
            tripleUnit = plural(triple, unitPlural)
        end

        if (triple >= 100) then
            tripleStr = hundreds[math.floor(triple / 100)]
            triple = triple % 100
        end

        if (triple >= 20) then
            tripleStr = tripleStr .. " " .. tens[math.floor(triple / 10)]
            triple = triple % 10
        end

        if (triple >= 1) then
            tripleStr = tripleStr .. " " .. ones[triple]
        end

        -- две тысячи
        if (triplePos == 2) then
            tripleStr = tripleStr:gsub("один$", "одна"):gsub("два$", "две")
        end

        out = tripleStr .. " " .. tripleUnit .. " " .. out
    end

    if (out == "") then
        out = zero
    end
    
    out = (trim(out) .. " " 
        .. plural(math.floor(tonumber(sum)), integersPlural) .. " " 
        .. decimal .. " " 
        .. plural(decimal, decimalsPlural)):gsub("%s%s", " ")
    return out
end
