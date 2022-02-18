--- fonts-and-alignment.lua - Enables setting font styles and text alignment in LaTex documents
---
--- Copyright: © 2021-2022 Nandakumar Chandrasekhar and Contributors
--- License: MIT - see LICENSE for details
-- Makes sure users know if their pandoc version is too old for this
-- filter.
--- fonts-and-alignment.lua - Enables setting font styles and text alignment in LaTex documents
---
--- Copyright: © 2021-2022 Nandakumar Chandrasekhar and Contributors
--- License: MIT - see LICENSE for details
-- Makes sure users know if their pandoc version is too old for this
-- filter.
PANDOC_VERSION:must_be_at_least '2.14'

-- The table below is categorized according to element tag either Span or Div
-- and then uner each element tag we have set of styles that apply to that tag.
-- Those styles in turn correspond to another table containing two values.
-- The element at index 1 is the LaTeX begin code and the element at index 2 is
-- LaTeX end code.
LATEX_CODES_FOR_TAGS = {
  Span = {
    -- Font Styles
    bold = { '\\textbf{', '}' },
    italic = { '\\textit{', '}' },
    monospace = { '\\texttt{', '}' },
    sans = { '\\textsf{', '}' },
    serif = { '\\textrm{', '}' },
    slanted = { '\\textsl{', '}' },
    smallcaps = { '\\textsc{', '}' },

    -- Font Sizes
    xxsmall = { '\\scriptsize ', nil },
    xsmall = { '\\footnotesize ', nil },
    small = { '\\small ', nil },
    normal = { '\\normalsize ', nil },
    large = { '\\large ', nil },
    xlarge = { '\\Large ', nil },
    xxlarge = { '\\LARGE ', nil },
  },
  Div = {
    -- Font Styles
    bold = { '\\begin{bfseries}', '\\end{bfseries}' },
    italic = { '\\begin{itshape}', '\\end{itshape}' },
    monospace = { '\\begin{ttfamily}', '\\end{ttfamily}' },
    sans = { '\\begin{sffamily}', '\\end{sffamily}' },
    serif = { '\\begin{rmfamily}', '\\end{rmfamily}' },
    slanted = { '\\begin{slshape}', '\\end{slshape}' },
    smallcaps = { '\\begin{scshape}',  '\\end{scshape}' },

    -- Font Sizes
    xxsmall = { '\\begin{scriptsize}', '\\end{scriptsize}' },
    xsmall = { '\\begin{footnotesize}', '\\end{footnotesize}' },
    small = { '\\begin{small}', '\\end{small}' },
    normal = { '\\begin{normalsize}', '\\end{normalsize}' },
    large = { '\\begin{large}', '\\end{large}' },
    xlarge = { '\\begin{Large}', '\\end{Large}' },
    xxlarge = { '\\begin{LARGE}', '\\end{LARGE}' },

    -- Layouts
    center = { '\\begin{center}', '\\end{center}' },
    flushright = { '\\begin{flushright}', '\\end{flushright}' },
    flushleft = { '\\begin{flushleft}', '\\end{flushleft}' },
    centering = { '\\begin{centering}', '\\end{centering}' },
    raggedleft = { '\\begin{raggedleft}', '\\end{raggedleft}' },
    raggedright = { '\\begin{raggedright}', '\\end{raggedright}' },
  }
}

local raw_code_function = {
  Span = pandoc.RawInline,
  Div = pandoc.RawBlock
}

-- This function takes an element object and returns it with
-- the LaTeX codes applied based on the class attached to the element
local function handler (elem)
  local tag = elem.tag
  local raw = raw_code_function[tag]
  local code_for_class = LATEX_CODES_FOR_TAGS[tag]

  -- Retrieve the class and the corresponding code and check if any
  -- of them are specified for the element. If yes add the LaTeX codes.
  for class, code in pairs(code_for_class) do
    if elem.classes:includes(class) then
      local begin_code = code[1] -- LaTeX code placed in front
      local end_code = code[2] -- LaTeX code placed at the end
      table.insert(elem.content, 1, raw('latex', begin_code))
      if end_code then
        table.insert(elem.content, raw('latex', end_code))
      end
    end
  end
  return elem
end

-- Call handler for each Span and Div element
Span = handler
Div = handler