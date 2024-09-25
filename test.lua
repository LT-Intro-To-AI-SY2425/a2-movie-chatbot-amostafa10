local function remove_n(t, n)
    for _ = 1, n do
      table.remove(t, 1)
    end
  end
  
  local function match(pattern, source)
    table.insert(source, "")
    local output = {}
    
    for patternIndex, patternString in ipairs(pattern) do
      local percentMatchResult = ""
      local percentMatchLength = 0
      local nextPatternString = pattern[patternIndex + 1]
      
      if #source == 0 then
        return nil
      end
      
      for sourceIndex, sourceString in ipairs(source) do
        if patternString == "%" then
          if sourceString == nextPatternString then
            percentMatchResult = percentMatchResult:sub(1, #percentMatchResult - 1)
            table.insert(output, percentMatchResult)
            remove_n(source, percentMatchLength)
            break
          else
            local lastWord = sourceIndex == #source
            if sourceString ~= "" then
              percentMatchResult = percentMatchResult .. sourceString .. " "
              percentMatchLength = percentMatchLength + 1
            end
            if lastWord then
              percentMatchResult = percentMatchResult:sub(1, #percentMatchResult - 1)
              table.insert(output, percentMatchResult)
              remove_n(source, percentMatchLength)
            end
          end
        elseif patternString == "_" then
          table.insert(output, sourceString)
          table.remove(source, sourceIndex)
          break
        else
          if sourceString == patternString then
            table.remove(source, sourceIndex)
            break
          end
          return
        end
      end
    end
  
    if #source > 0 and source[1] ~= "" then
      return nil
    end
    
    -- debugging--
    
    if type(output) == "table" then
      setmetatable(output, {
        __eq = function(a, b)
          for k, v in pairs(a) do
            if b[k] ~= v then
              return false
            end
          end
          return true
        end
      })
    end
    
    --------------
  
    return output
  end
  
  
  
  -------- tests --------
  
  assert(match({"x", "y", "z"}, {"x", "y", "z"}) == {}, "test 1 failed")
  assert(match({"x", "z", "z"}, {"x", "y", "z"}) == nil, "test 2 failed")
  assert(match({"x", "y"}, {"x", "y", "z"}) == nil, "test 3 failed")
  assert(match({"x", "y", "z", "z"}, {"x", "y", "z"}) == nil, "test 4 failed")
  assert(match({"x", "_", "z"}, {"x", "y", "z"}) == {"y"}, "test 5 failed")
  assert(match({"x", "_", "_"}, {"x", "y", "z"}) == {"y", "z"}, "test 6 failed")
  assert(match({"%"}, {"x", "y", "z"}) == {"x y z"}, "test 7 failed")
  assert(match({"x", "%", "z"}, {"x", "y", "z"}) == {"y"}, "test 8 failed")
  assert(match({"%", "z"}, {"x", "y", "z"}) == {"x y"}, "test 9 failed")
  assert(match({"x", "%", "y"}, {"x", "y", "z"}) == nil, "test 10 failed")
  assert(match({"x", "%", "y", "z"}, {"x", "y", "z"}) == {""}, "test 11 failed")
  assert(match({"x", "y", "z", "%"}, {"x", "y", "z"}) == {""}, "test 12 failed")
  assert(match({"_", "%"}, {"x", "y", "z"}) == {"x", "y z"}, "test 13 failed")
  assert(match({"_", "_", "_", "%"}, {"x", "y", "z"}) == {"x", "y", "z", "",}, "test 14 failed")
  assert(match({"x", "%", "z"}, {"x", "y", "z", "z", "z"}) == nil, "test 15 failed")
  print("passed")