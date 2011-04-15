f = File.read("templates/index_code.txt")
code = CodeRay.highlight f, "c"

code.gsub! 'CodeRay', 'CR'

email = "bkrsta@bkrsta.co.cc"
require 'uri'
email_subj = URI.escape("Email from blog visitor")
