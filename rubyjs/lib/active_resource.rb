# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class ActiveResource
  attr_accessor :attributes
  
  def initialize(attrs)
    @attributes = attrs
  end
  
  def method_missing(method, *args)
    if method =~ /(.*)=$/
      attributes[$1] = args[0]
    elsif attributes[method]
      attributes[method]
    else
      super
    end
  end
  
  def self.find(id)
    HTTPRequest.asyncGet "/customers/#{id}.json" do |json|
      hash = JSON.load(json)
      yield Customer.new(hash["customer"])
    end    
  end
  
  def save
    request_json = {:customer => attributes}.to_json
    HTTPRequest.asyncImpl "/customers/#{id}.json", "PUT", request_json, "application/json" do |json|
      puts json
      self.attributes = JSON.load(json)
    end
  end
  
  def to_json
    attributes.to_json
  end  
end
