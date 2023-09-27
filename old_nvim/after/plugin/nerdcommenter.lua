v = vim.g

--" Create default mappings
v.NERDCreateDefaultMappings = 1

--" Add spaces after comment delimiters by default 
v.NERDSpaceDelims = 1

--" Use compact syntax for prettified multi-line comments
v.NERDCompactSexyComs = 1

-- Align line-wise comment delimiters flush left instead of following code indentation
v.NERDDefaultAlign = 'left'

-- Set a language to use its alternate delimiters by default
v.NERDAltDelims_java = 1

-- Add your own custom formats or override the defaults
--v.NERDCustomDelimiters = { 'c': { 'left': "/**","right": ""*/" } }

-- Allow commenting and inverting empty lines (useful when commenting a region)

v.NERDCommentEmptyLines = 1
-- Enable trimming of trailing whitespace when uncommenting
v.NERDTrimTrailingWhitespace = 1

-- Enable NERDCommenterToggle to check all selected lines is commented or not 
v.NERDToggleCheckAllLines = 1

