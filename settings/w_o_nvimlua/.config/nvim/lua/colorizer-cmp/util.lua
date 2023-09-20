local M = {}

local function shortToExtended(hex)
  local r = hex:sub(2, 2)
  local g = hex:sub(3, 3)
  local b = hex:sub(4, 4)
  local a = hex:sub(5, 5) or 'f'
  return '#' .. r .. r .. g .. g .. b .. b .. a .. a
end

--[[ local function extractHSL(str)
  local h, s, l, a = str:match 'hsla?%(([%d%.]+)[^%d]+([%d%.]+)[^%d]+([%d%.]+)[^%d]*([%d%.]*)'
  if not h then
    return nil
  end
  return tonumber(h), tonumber(s), tonumber(l), tonumber(a)
end ]]

local function extractColorComponents(str, colorFnc)
  local val1, val2, val3, val4
  if colorFnc == 'hsl' then
    val1, val2, val3, val4 = str:match 'hsla?%(([%d%.]+)[^%d]+([%d%.]+)[^%d]+([%d%.]+)[^%d]*([%d%.]*)'
  end

  if colorFnc == 'rgb' then
    val1, val2, val3, val4 = str:match 'rgba?%(([%d]+)[,%s]*([%d]+)[,%s]*([%d]+)[,%s/]?.*([%d]*%.?%d*)%s*%)'
  end

  if not val1 then
    return nil
  end

  return tonumber(val1), tonumber(val2), tonumber(val3), tonumber(val4)
end

local function rgbToHex(r, g, b)
  r = math.floor(r)
  g = math.floor(g)
  b = math.floor(b)
  return string.format('#%02x%02x%02x', r, g, b)
end

local function hslToHex(h, s, l)
  -- Convert HSL values to 0-1 range
  h = h / 360
  s = s / 100
  l = l / 100

  -- Calculate RGB values
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    local function hueToRgb(p, q, t)
      if t < 0 then
        t = t + 1
      end
      if t > 1 then
        t = t - 1
      end
      if t < 1 / 6 then
        return p + (q - p) * 6 * t
      end
      if t < 1 / 2 then
        return q
      end
      if t < 2 / 3 then
        return p + (q - p) * (2 / 3 - t) * 6
      end
      return p
    end

    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hueToRgb(p, q, h + 1 / 3)
    g = hueToRgb(p, q, h)
    b = hueToRgb(p, q, h - 1 / 3)
  end

  -- Convert RGB values to hexadecimal string
  return string.format('#%02x%02x%02x', r * 255, g * 255, b * 255)
end

local function getTextColor(hexColor)
  -- Convert hex color code to RGB values
  local r = tonumber(string.sub(hexColor, 2, 3), 16)
  local g = tonumber(string.sub(hexColor, 4, 5), 16)
  local b = tonumber(string.sub(hexColor, 6, 7), 16)

  -- Calculate perceived brightness using the YIQ color space
  local brightness = (r * 299 + g * 587 + b * 114) / 1000

  -- Return white text color if the background is dark, black otherwise
  if brightness < 128 then
    return '#ffffff' -- white
  else
    return '#000000' -- black
  end
end

function M.colorBgFg(doc)
  -- return nil if doc nil
  if not doc then
    return nil
  end

  if string.match(doc, '^#') then
    local color, a

    -- Color is in hex #rgba
    if string.match(doc, '^#(%x%x%x%x)$') or string.match(doc, '^#(%x%x%x)$') then
      color = shortToExtended(doc)
    end

    -- Color is in hex #rrggbb
    if string.match(doc, '^#(%x%x%x%x%x%x)$') or string.match(doc, '^#(%x%x%x%x%x%x%x%x)$') then
      color = doc
    end

    color, a = color:sub(1, 7), color:sub(8, 9)

    return color, getTextColor(color), a
  end

  -- Support for rgb
  if string.match(doc, '^rgb') then
    local r, g, b, a = extractColorComponents(doc, 'rgb')
    if r and g and b then
      return rgbToHex(r, g, b), getTextColor(rgbToHex(r, g, b)), a
    end
  end

  -- Support for hsl
  if string.match(doc, '^hsl') then
    local h, s, l, a = extractColorComponents(doc, 'hsl')
    if h and s and l then
      return hslToHex(h, s, l), getTextColor(hslToHex(h, s, l)), a
    end
  end

  -- TODO: Add more color functions: hwb, lab, lch, oklab, oklch, color(not sure about this one, but we will see.)

  -- No color found
  return nil
end

return M
