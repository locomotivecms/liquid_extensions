require 'ostruct'

class CustomModel < OpenStruct

  def attributes=(attributes)
    attributes.each do |key, value|
      send(:"#{key}=", value)
    end
  end

  def to_liquid
    CustomDrop.new(self)
  end

end

class CustomDrop < Liquid::Drop

  attr_accessor :_source

  def initialize(source)
    self._source = source
  end

  def before_method(meth)
    self._source.marshal_dump[meth.to_sym]
  end

end