-- if FORMAT:match 'latex' then
--   Str = function (elem)
--     if elem.text == "{{aside}}" then
--       return pandoc.RawInline('latex', '\\begin{tcolorbox}[breakable, colframe=Apricot!40!white, colback=Apricot!10!white, boxsep=2mm]')
--     else if elem.text == "{{end}}" then
--       return pandoc.RawInline('latex', '\\end{tcolorbox}')
--     else
--       return elem
--     end
--   end
-- end
-- else if FORMAT:match 'html' then
--   Str = function (elem)
--     if elem.text == "{{aside}}" then
--       return pandoc.RawInline('html', '<div class="Warning">')
--     else if elem.text == "{{end}}" then
--       return pandoc.RawInline('html', '</div>')
--     else
--       return elem
--     end
--   end
-- end
-- else if FORMAT:match 'docx' then
--   Str = function (elem)
--     if elem.text == "{{aside}}" then
--       return pandoc.Div('', '<div custom-style="Aside">')
--     else if elem.text == "{{end}}" then
--       return pandoc.Div('', '</div>')
--     else
--       return elem
--     end
--   end
-- end
-- end
-- end
-- end

if FORMAT:match 'docx' then
  Div = function (elem)
    if elem.classes[1] == "Aside" then
      elem.attributes['custom-style'] = 'Aside'
      return elem
    else if elem.classes[1] == "Questions" then
      elem.attributes['custom-style'] = 'QuestionList'
      return elem
    else
      return elem
    end
  end
end
else if FORMAT:match 'latex' then
  Div = function (elem)
    if elem.classes[1] == "Aside" then
      return {
        pandoc.RawBlock('latex', '\\begin{tcolorbox}[breakable, colframe=Apricot!40!white, colback=Apricot!10!white, boxsep=2mm]'),
        elem,
        pandoc.RawBlock('latex', '\\end{tcolorbox}')
      }
    else if elem.classes[1] == "Questions" then
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
end
end
