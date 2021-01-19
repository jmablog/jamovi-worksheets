function Div (elem)
  if FORMAT:match 'docx' then
    if elem.classes[1] == "Aside" then
      elem.attributes['custom-style'] = 'Aside'
      return elem
    elseif elem.classes[1] == "Questions" then
      elem.attributes['custom-style'] = 'QuestionList'
      return elem
    else
      return elem
    end
  elseif FORMAT:match 'latex' then
    if elem.classes[1] == "Aside" then
      return {
        pandoc.RawBlock('latex', '\\begin{tcolorbox}[breakable, colframe=Apricot!40!white, colback=Apricot!10!white, boxsep=2mm]'),
        elem,
        pandoc.RawBlock('latex', '\\end{tcolorbox}')
      }
    elseif elem.classes[1] == "Questions" then
      return {
        pandoc.RawBlock('latex', '\\begin{tcolorbox}[breakable, colframe=black!50!white, colback=black!3!white, boxsep=2mm]'),
        elem,
        pandoc.RawBlock('latex', '\\end{tcolorbox}')
      }
    else
      return elem
    end
  end
end

--[[
pagebreak – convert raw LaTeX page breaks to other formats

Copyright © 2017-2020 Benct Philip Jonsson, Albert Krewinkel

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
]]
local stringify_orig = (require 'pandoc.utils').stringify

local function stringify(x)
  return type(x) == 'string' and x or stringify_orig(x)
end

--[[
Word ToC shortcode
]]

local toccode = {
  ooxml = '<w:p><w:r><w:br w:type="page"/></w:r></w:p><w:sdt><w:sdtPr><w:docPartObj><w:docPartGallery w:val="Table of Contents" /><w:docPartUnique /></w:docPartObj></w:sdtPr><w:sdtContent><w:p><w:pPr><w:pStyle w:val="TOCHeading" /></w:pPr><w:r><w:t>Contents</w:t></w:r></w:p><w:p><w:r><w:fldChar w:fldCharType="begin" w:dirty="true" /><w:instrText xml:space="preserve"> TOC \\o "1-3" \\h \\z \\u </w:instrText><w:fldChar w:fldCharType="separate" /><w:fldChar w:fldCharType="end" /></w:r></w:p></w:sdtContent></w:sdt><w:p><w:r><w:br w:type="page"/></w:r></w:p>'
}

--- Return a block element insert a Word ToC field
local function wordtoc(format)
  if format:match 'docx' then
    return pandoc.RawBlock('openxml', toccode.ooxml)
  elseif format:match 'latex' then
    return pandoc.RawBlock('latex', '\\')
  end
end

local function is_wordtoc_command(command)
  return command:match '^\\wordtoc%{?%}?$'
end

--[[
pagebreak – convert raw LaTeX page breaks to other formats
]]

local stringify_orig = (require 'pandoc.utils').stringify

local function stringify(x)
  return type(x) == 'string' and x or stringify_orig(x)
end

--- configs – these are populated in the Meta filter.
local pagebreak = {
  asciidoc = '<<<\n\n',
  context = '\\page',
  epub = '<p style="page-break-after: always;"> </p>',
  html = '<div style="page-break-after: always;"></div>',
  latex = '\\newpage{}',
  ms = '.bp',
  ooxml = '<w:p><w:r><w:br w:type="page"/></w:r></w:p>',
  odt = '<text:p text:style-name="Pagebreak"/>'
}

local function pagebreaks_from_config (meta)
  local html_class =
    (meta.newpage_html_class and stringify(meta.newpage_html_class))
    or os.getenv 'PANDOC_NEWPAGE_HTML_CLASS'
  if html_class and html_class ~= '' then
    pagebreak.html = string.format('<div class="%s"></div>', html_class)
  end

  local odt_style =
    (meta.newpage_odt_style and stringify(meta.newpage_odt_style))
    or os.getenv 'PANDOC_NEWPAGE_ODT_STYLE'
  if odt_style and odt_style ~= '' then
    pagebreak.odt = string.format('<text:p text:style-name="%s"/>', odt_style)
  end
end

--- Return a block element causing a page break in the given format.
local function newpage(format)
  if format:match 'asciidoc' then
    return pandoc.RawBlock('asciidoc', pagebreak.asciidoc)
  elseif format == 'context' then
    return pandoc.RawBlock('context', pagebreak.context)
  elseif format == 'docx' then
    return pandoc.RawBlock('openxml', pagebreak.ooxml)
  elseif format:match 'epub' then
    return pandoc.RawBlock('html', pagebreak.epub)
  elseif format:match 'html.*' then
    return pandoc.RawBlock('html', pagebreak.html)
  elseif format:match 'latex' then
    return pandoc.RawBlock('tex', pagebreak.latex)
  elseif format:match 'ms' then
    return pandoc.RawBlock('ms', pagebreak.ms)
  elseif format:match 'odt' then
    return pandoc.RawBlock('opendocument', pagebreak.odt)
  else
    -- fall back to insert a form feed character
    return pandoc.Para{pandoc.Str '\f'}
  end
end

local function is_newpage_command(command)
  return command:match '^\\newpage%{?%}?$'
    or command:match '^\\pagebreak%{?%}?$'
end

-- Filter function called on each RawBlock element.
function RawBlock (el)
  -- check that the block is TeX or LaTeX and contains only
  -- \wordtoc
  if el.format:match 'tex' and is_wordtoc_command(el.text) then
    -- return code for word toc. FORMAT is set by pandoc to
    -- the targeted output format.
    return wordtoc(FORMAT)
  -- check that the block is TeX or LaTeX and contains only
  -- \newpage or pagebreak
  elseif el.format:match 'tex' and is_newpage_command(el.text) then
      -- use format-specific pagebreak marker. FORMAT is set by pandoc to
      -- the targeted output format.
      return newpage(FORMAT)
  end
  -- otherwise, leave the block unchanged
  return el
end

return {
  {RawBlock = RawBlock, Div = Div}
}