require 'net/http'
require 'json'
require 'xmlsimple'

module Rladin 

  ALADIN_URL = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx"

  class RladinError < StandardError; end
  class Result
    attr_accessor :link, :item, :version, :query, :totalResults, :startIndex, :itemsPerPage
    def initialize(hash)
      hash.each do |k,v|
        self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
      end
    end
  end

  def self.search(ttbkey, query, format="js", extra_params=nil)
    uri = URI(ALADIN_URL)
    params = {TTBKey:ttbkey, Query:query, Output:format, SearchTarget:"Book"}
    params.merge! extra_params if extra_params
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP::get_response uri
    case res
    when Net::HTTPSuccess
      self.parsebody format, res.body 
    else
      res.error!
    end
  rescue Exception => e
    raise e
  end

  private 

  def self.parsebody(format, body)
    raise RladinError.new(body) if body.include? 'errorCode'
    case format
    when "js" then
      valid_str = body.gsub(/;/, '') 
      Result.new(JSON.parse(valid_str))
    when "xml" then
      Result.new(XmlSimple.xml_in(body, { 'ForceArray' => false }))
    else
      body
    end
  end
    
end