Infosell.configure do |infosell|
  
  infosell.type = :info
  infosell.site = "http://172.20.192.14:8092/"
  
  infosell.cache = {
    :service => 1.hour
  }
  
end
