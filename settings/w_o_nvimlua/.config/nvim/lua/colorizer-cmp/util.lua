-- ############################################################
-- Color Conversion Module
-- Implemented: HWB, LAB, LCH, OKLAB, OKLCH, color()
-- Returns: bgHex, fgHex, alpha (alpha may be nil)
-- ############################################################

local M = {}

--------------------------------------------------------------
-- Utilities
--------------------------------------------------------------

local function clamp(v, a, b)
  if v < a then return a end
  if v > b then return b end
  return v
end

local function shortToExtended(hex)
  local r = hex:sub(2, 2)
  local g = hex:sub(3, 3)
  local b = hex:sub(4, 4)
  local a = hex:sub(5, 5) or 'f'
  return '#' .. r .. r .. g .. g .. b .. b .. a .. a
end

local function parseNumbers(str)
  -- return numeric tokens found in string (simple, ignores units)
  local out = {}
  for num in str:gmatch('[-%d%.]+') do
    table.insert(out, tonumber(num))
  end
  return out
end

local function toHexByte(x)
  x = math.floor(clamp(x, 0, 255) + 0.5)
  return string.format('%02x', x)
end

local function rgbToHex(r, g, b)
  return '#' .. toHexByte(r) .. toHexByte(g) .. toHexByte(b)
end

local function linearToSRGB(c)
  if c <= 0.0031308 then
    return 12.92 * c
  else
    return 1.055 * (c ^ (1 / 2.4)) - 0.055
  end
end

local function srgbGammaAndClamp(rLin, gLin, bLin)
  local r = linearToSRGB(rLin)
  local g = linearToSRGB(gLin)
  local b = linearToSRGB(bLin)
  -- clamp 0..1 then to 0..255
  return clamp(r, 0, 1) * 255, clamp(g, 0, 1) * 255, clamp(b, 0, 1) * 255
end

--------------------------------------------------------------
-- HSL helper (scaled h 0..360, s/l in percent)
-- (Used earlier in module)
--------------------------------------------------------------

local function hslToHex(h, s, l)
  h = h / 360
  s = s / 100
  l = l / 100

  local r, g, b

  if s == 0 then
    r, g, b = l, l, l
  else
    local function hueToRgb(p, q, t)
      if t < 0 then t = t + 1 end
      if t > 1 then t = t - 1 end
      if t < 1/6  then return p + (q - p) * 6 * t end
      if t < 1/2  then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q

    r = hueToRgb(p, q, h + 1/3)
    g = hueToRgb(p, q, h)
    b = hueToRgb(p, q, h - 1/3)
  end

  return string.format('#%02x%02x%02x', r * 255, g * 255, b * 255)
end

--------------------------------------------------------------
-- HWB -> RGB -> HEX
-- h in degrees, w and b in percent
-- Algorithm: convert hue to RGB at full saturation/value, then mix with white and black
--------------------------------------------------------------
local function hwbToHex(h, w, bl)
  -- Normalize
  h = (h % 360 + 360) % 360
  w = w / 100
  bl = bl / 100

  local ratio = w + bl
  if ratio >= 1 then
    -- pure gray: white fraction dominates
    local gray = w / ratio
    local v = gray * 255
    return rgbToHex(v, v, v)
  end

  -- Convert hue to base RGB with v = 1, s = 1 using HSV formula
  local hh = h / 60
  local i = math.floor(hh)
  local f = hh - i
  -- local p = 0
  local q = 1 - f
  local t = f

  local r1, g1, b1
  if i == 0 then r1, g1, b1 = 1, t, 0
  elseif i == 1 then r1, g1, b1 = q, 1, 0
  elseif i == 2 then r1, g1, b1 = 0, 1, t
  elseif i == 3 then r1, g1, b1 = 0, q, 1
  elseif i == 4 then r1, g1, b1 = t, 0, 1
  else r1, g1, b1 = 1, 0, q end

  -- Mix with white and black
  local factor = 1 - w - bl
  local r = r1 * factor + w
  local g = g1 * factor + w
  local b = b1 * factor + w

  return rgbToHex(r * 255, g * 255, b * 255)
end

--------------------------------------------------------------
-- CIE Lab -> XYZ -> linear sRGB -> HEX
-- Uses D65 reference white (95.047, 100.0, 108.883)
--------------------------------------------------------------
local function labToHex(L, a, b)
  -- Input L expected as 0..100 (if provided fraction, user should pass 0..100)
  -- If L appears to be 0..1, scale to 0..100 (heuristic)
  if L and L <= 1 then L = L * 100 end

  local fy = (L + 16) / 116
  local fx = a / 500 + fy
  local fz = fy - b / 200

  local function fInv(t)
    local t3 = t * t * t
    if t3 > 0.008856 then
      return t3
    else
      return (t - 16/116) / 7.787
    end
  end

  local Xn, Yn, Zn = 95.047, 100.000, 108.883

  local xr = fInv(fx)
  local yr = fInv(fy)
  local zr = fInv(fz)

  local X = xr * Xn
  local Y = yr * Yn
  local Z = zr * Zn

  -- convert XYZ (scaled 0..100) to linear sRGB
  local x = X / 100
  local y = Y / 100
  local z = Z / 100

  local rLin =  x *  3.2406 + y * -1.5372 + z * -0.4986
  local gLin =  x * -0.9689 + y *  1.8758 + z *  0.0415
  local bLin =  x *  0.0557 + y * -0.2040 + z *  1.0570

  local r, g, bOut = srgbGammaAndClamp(rLin, gLin, bLin)
  return rgbToHex(r, g, bOut)
end

--------------------------------------------------------------
-- LCH -> Lab helper
--------------------------------------------------------------
local function lchToLab(L, C, h)
  -- h in degrees
  local hr = math.rad(h or 0)
  local a = C * math.cos(hr)
  local b = C * math.sin(hr)
  return L, a, b
end

--------------------------------------------------------------
-- OKLab / OKLCH conversions
-- Implementation based on standard Oklab formulas
--------------------------------------------------------------
-- local function cbrt(x)
--   if x >= 0 then return x^(1/3) else return -((-x)^(1/3)) end
-- end

local function oklabToHex(L, a, b)
  -- convert oklab to linear sRGB
  -- first convert to l,m,s
  local l_ = L + 0.3963377774 * a + 0.2158037573 * b
  local m_ = L - 0.1055613458 * a - 0.0638541728 * b
  local s_ = L - 0.0894841775 * a - 1.2914855480 * b

  local l = l_ * l_ * l_
  local m = m_ * m_ * m_
  local s = s_ * s_ * s_

  local rLin = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
  local gLin = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
  local bLin = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s

  local r, g, bOut = srgbGammaAndClamp(rLin, gLin, bLin)
  return rgbToHex(r, g, bOut)
end

local function hexFromOklch(L, C, h)
  -- convert to a,b then use oklabToHex
  local hr = math.rad(h or 0)
  local a = C * math.cos(hr)
  local b = C * math.sin(hr)
  return oklabToHex(L, a, b)
end

--------------------------------------------------------------
-- CSS generic color parser / converters for: lab(), lch(), oklab(), oklch(), hwb(), color()
-- Basic numeric extraction (not full CSS grammar)
--------------------------------------------------------------
local function parseFunctionArgs(funcStr)
  -- return numeric tokens and alpha if present (if separated by '/')
  -- We'll treat the slash form "..., /, alpha" by splitting
  local alpha = nil
  local main = funcStr
  -- local slashPos = funcStr:match('.*/') and true or false
  -- Better: if there's a '/', take trailing numeric tokens after slash as alpha
  local slashIndex = funcStr:find('/')
  if slashIndex then
    main = funcStr:sub(1, slashIndex - 1)
    local after = funcStr:sub(slashIndex + 1)
    local toks = parseNumbers(after)
    if toks[1] then alpha = toks[1] end
  end
  local tokens = parseNumbers(main)
  return tokens, alpha
end

--------------------------------------------------------------
-- getTextColor: same luminance-based choice as earlier
--------------------------------------------------------------
local function getTextColor(hexColor)
  local r = tonumber(hexColor:sub(2, 3), 16)
  local g = tonumber(hexColor:sub(4, 5), 16)
  local b = tonumber(hexColor:sub(6, 7), 16)
  local brightness = (r * 299 + g * 587 + b * 114) / 1000
  return brightness < 128 and '#ffffff' or '#000000'
end

--------------------------------------------------------------
-- Simple extractors for rgb/hsl/hwb/lab/lch/oklab/oklch/color()
-- (color() we accept "color(display-p3 r g b / a)" and simple "color(srgb r g b / a)" not full spec)
--------------------------------------------------------------
local function extractColorComponents(str, colorFnc)
  colorFnc = colorFnc:lower()
  if colorFnc == 'rgb' then
    -- rgb/rgba
    local nums, alpha = parseFunctionArgs(str)
    return nums[1], nums[2], nums[3], alpha or nums[4]
  end

  if colorFnc == 'hsl' then
    local nums, alpha = parseFunctionArgs(str)
    return nums[1], nums[2], nums[3], alpha or nums[4]
  end

  if colorFnc == 'hwb' then
    local nums, alpha = parseFunctionArgs(str)
    return nums[1], nums[2], nums[3], alpha or nums[4]
  end

  if colorFnc == 'lab' then
    local nums, alpha = parseFunctionArgs(str)
    -- CSS L is percent (0%..100%) in many usages; our parseNumbers strips '%', so assume direct numbers.
    return nums[1], nums[2], nums[3], alpha or nums[4]
  end

  if colorFnc == 'lch' then
    local nums, alpha = parseFunctionArgs(str)
    return nums[1], nums[2], nums[3], alpha or nums[4]
  end

  if colorFnc == 'oklab' then
    local nums, alpha = parseFunctionArgs(str)
    return nums[1], nums[2], nums[3], alpha or nums[4]
  end

  if colorFnc == 'oklch' then
    local nums, alpha = parseFunctionArgs(str)
    return nums[1], nums[2], nums[3], alpha or nums[4]
  end

  if colorFnc == 'color' then
    -- Accept: color(srgb r g b / a) or color(display-p3 r g b / a)
    -- We'll attempt to detect 'srgb' or 'display-p3' or 'oklab' inside
    local inner = str:match('color%((.+)%)')
    if not inner then return nil end
    -- trim
    inner = inner:gsub('^%s+', ''):gsub('%s+$', '')
    -- check prefix
    local prefix = inner:match('^([%w%-]+)')
    if prefix == 'srgb' or prefix == 'display-p3' then
      -- strip prefix
      local rest = inner:sub(#prefix + 1)
      local nums, alpha = parseFunctionArgs(rest)
      return nums[1], nums[2], nums[3], alpha or nums[4], prefix
    end
    -- fall through to trying generic numeric parse
    local nums, alpha = parseFunctionArgs(inner)
    return nums[1], nums[2], nums[3], alpha or nums[4]
  end

  return nil
end

--------------------------------------------------------------
-- Main API: colorBgFg
--------------------------------------------------------------
function M.colorBgFg(doc)
  if (not doc) or (type(doc) == "table") then
    return nil
  end

  -- HEX handling
  if doc:match('^#') then
    local color = nil
    if doc:match('^#%x%x%x$') or doc:match('^#%x%x%x%x$') then
      color = shortToExtended(doc)
    elseif doc:match('^#%x%x%x%x%x%x$') or doc:match('^#%x%x%x%x%x%x%x%x$') then
      color = doc
    else
      return nil
    end
    local rgb = color:sub(1, 7)
    local a = color:sub(8, 9)
    return rgb, getTextColor(rgb), a
  end

  -- rgb()
  if doc:match('^%s*rgb') then
    local r, g, b, a = extractColorComponents(doc, 'rgb')
    if r and g and b then
      return rgbToHex(r, g, b), getTextColor(rgbToHex(r,g,b)), a
    end
  end

  -- hsl()
  if doc:match('^%s*hsl') then
    local h, s, l, a = extractColorComponents(doc, 'hsl')
    if h and s and l then
      local hex = hslToHex(h, s, l)
      return hex, getTextColor(hex), a
    end
  end

  -- hwb()
  if doc:match('^%s*hwb') then
    local h, w, bl, a = extractColorComponents(doc, 'hwb')
    if h and w and bl then
      local hex = hwbToHex(h, w, bl)
      return hex, getTextColor(hex), a
    end
  end

  -- lab()
  if doc:match('^%s*lab') then
    local L, aVal, bVal, a = extractColorComponents(doc, 'lab')
    if L and aVal and bVal then
      local hex = labToHex(L, aVal, bVal)
      return hex, getTextColor(hex), a
    end
  end

  -- lch()
  if doc:match('^%s*lch') then
    local L, C, h, a = extractColorComponents(doc, 'lch')
    if L and C and h then
      local L2, aVal, bVal = lchToLab(L, C, h)
      local hex = labToHex(L2, aVal, bVal)
      return hex, getTextColor(hex), a
    end
  end

  -- oklab()
  if doc:match('^%s*oklab') then
    local L, aVal, bVal, a = extractColorComponents(doc, 'oklab')
    if L and aVal and bVal then
      local hex = oklabToHex(L, aVal, bVal)
      return hex, getTextColor(hex), a
    end
  end

  -- oklch()
  if doc:match('^%s*oklch') then
    local L, C, h, a = extractColorComponents(doc, 'oklch')
    if L and C and h then
      local hex = hexFromOklch(L, C, h)
      return hex, getTextColor(hex), a
    end
  end

  -- color()
  if doc:match('^%s*color%(') then
    -- Basic support for color(srgb ...) or color(display-p3 ...) or bare numeric
    local nums, alpha, prefix
    local inner = doc:match('color%((.+)%)')
    if inner then
      -- detect srgb/display-p3 prefix
      local p = inner:match('^%s*([%w%-]+)')
      if p == 'srgb' or p == 'display-p3' then
        prefix = p
        local rest = inner:sub(#p + 1)
        nums, alpha = parseFunctionArgs(rest)
      else
        nums, alpha = parseFunctionArgs(inner)
      end

      if nums and nums[1] and nums[2] and nums[3] then
        -- if values >1 assume 0..255, else 0..1
        local r = nums[1]
        local g = nums[2]
        local b = nums[3]
        if r <= 1 and g <= 1 and b <= 1 then
          r = r * 255; g = g * 255; b = b * 255
        end
        local hex = rgbToHex(r, g, b)
        return hex, getTextColor(hex), alpha
      end
    end
  end

  return nil
end

return M

