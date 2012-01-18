require 'rladin'

describe Rladin, "#search" do 
  
  ttbkey = "ttbparangdaexxx"

  it "should return json result" do
    body = Rladin.search(ttbkey, 'ruby')
    body.version.should eq("20070901")
  end

  it "should return xml result" do
    body = Rladin.search(ttbkey, 'ruby', 'xml')
    body.version.should eq("20070901")
  end

  it "should return error result" do
    body = Rladin.search(ttbkey, 'qwert', 'xml', {:title => "hello"})
    body.version.should eq("20070901")
  end

end