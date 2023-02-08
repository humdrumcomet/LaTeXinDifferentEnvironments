-- convert list of targets and their substitution from text to a table where the key is the value to be replaced, and the value is the text being substituted
function optsToTable(opts)
    if opts == 'empty' then
        return {}
    end
    local interTbl = {}
    local inputs = {}
    local brackPat = '%s*(%b{})%s*=%s*(%b{}),*'
    for key, value in string.gmatch(opts, brackPat) do
        keymod = regexEsc(string.gsub(string.gsub(key, "^{", ""), "}$", ""))
        valuemod = string.gsub(string.gsub(value, "^{", ""), "}$", "")
        inputs[keymod] = valuemod
        print(keymod)
        print(valuemod)
    end
    return inputs
end

-- Strings used for regex must have special characters escaped, so make run keys (the target string) through regexEsc
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

function stringReplaceFromFile(replacementsPreTable, filePathIn, filePathOut)
    local optsTable = optsToTable(replacementsPreTable)
    local fileIn = io.open(filePathIn, 'r')
    local fileOut = io.open(filePathOut, 'w')
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
        fileOut:write(lineRemain, "\n")
    end

    fileIn:close()
    fileOut:close()

    return replacedString
end
