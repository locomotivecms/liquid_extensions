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

  def initialize(source)
    @_source = source
  end

  def before_method(meth)
    @_source.marshal_dump[meth.to_sym]
  end

end