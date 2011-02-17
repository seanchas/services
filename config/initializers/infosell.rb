Infosell.configure do |infosell|
  
  infosell.type = :info
  infosell.site = "http://blis1:8092/"
  
  infosell.cache = {
    :service => 1.hour
  }
  
end
