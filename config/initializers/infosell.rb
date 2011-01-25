Infosell.configure do |infosell|
  
  infosell.type = :info
  infosell.site = "http://dls8:8092/"
  
  infosell.cache = {
    :service => 1.hour
  }
  
end
