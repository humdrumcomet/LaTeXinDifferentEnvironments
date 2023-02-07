function optsToTable(opts)
    if opts == 'empty' then
        return {}
    end
    local interTbl = {}
    local inputs = {}
    -- local quotePat = "(%.+)%s*=%s*(%b''),*"
    -- local quoteRm = "%.+%s*=%s*%b'',*"
    local brackPat = '%s*(%b{})%s*=%s*(%b{}),*'
    -- local brackRm = '%.+%s*=%s*%b{},*'
    -- local commaPat = '([^,]+)'
    -- local equalsPat = '(%.+)%s*=%s*(.*),*'
    -- for key, value in string.gmatch(opts, quotePat) do
    --     local inter = string.gsub(value, "'$", "")
    --     local item = string.gsub(inter, "^'", "")
    --     inputs[key] = item
    --     print(inputs[key])
    -- end
    for key, value in string.gmatch(opts, brackPat) do
        keymod = regexEsc(string.gsub(string.gsub(key, "^{", ""), "}$", ""))
        valuemod = string.gsub(string.gsub(value, "^{", ""), "}$", "")
        inputs[keymod] = valuemod
        print(keymod)
        print(valuemod)
    end
    -- local strItemRemoved = string.gsub(opts, quoteRm, '')
    -- local tblItemRemoved = string.gsub(strItemRemoved, brackRm, '')
    -- for set in string.gmatch(tblItemRemoved, commaPat) do
    --     for key, value in string.gmatch(set, equalsPat) do
    --         inputs[key] = value
    --         print(inputs[key])
    --     end
    -- end
    return inputs
end

function regexEsc(x)
   return (x:gsub('%%', '%%%%')
            :gsub('^%^', '%%^')
            :gsub('%$$', '%%$')
            :gsub('%(', '%%(')
            :gsub('%)', '%%)')
            :gsub('%.', '%%.')
            :gsub('%[', '%%[')
            :gsub('%]', '%%]')
            :gsub('%*', '%%*')
            :gsub('%+', '%%+')
            :gsub('%-', '%%-')
            :gsub('%?', '%%?'))
end

function stringReplaceFromFile(replacementsPreTable, filepath)
    local optsTable = optsToTable(replacementsPreTable)
    local fileIn = io.open(filepath)
    local replacedString = ''
    local lineRemain = ''
    local netSub = 0

    for line in fileIn:lines() do
        lineRemain = line
        netSub = 0
        for target, substitution in pairs(optsTable) do
          lineRemain, numSub = string.gsub(lineRemain, target, substitution)
            netSub = netSub + numSub
        end
        replacedString = replacedString .. "\n" .. lineRemain
        if netSub>0 then
            print("original line: "..line)
            print("subbed line:   "..lineRemain)
        else
            print(netSub)
        end
        tex.sprint(lineRemain)
    end

    return replacedString
end
