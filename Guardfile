# vim: set ft=ruby :

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'markdown', convert_on_start: true do
  watch(%r{^pages/(.+).md$} ){|m| "pages/#{m[1]}.md|./#{m[1]}.html|pages/_template.html" }
end
