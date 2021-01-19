if FORMAT:match 'docx' then
  Div = function (elem)
    if elem.classes[1] == "Aside" then
      elem.attributes['custom-style'] = 'Aside'
      return elem
    elseif elem.classes[1] == "Questions" then
      elem.attributes['custom-style'] = 'QuestionList'
      return elem
    else
      return elem
    end
  end
elseif FORMAT:match 'latex' then
  Div = function (elem)
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
