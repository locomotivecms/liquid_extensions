class SimplePage

  attr_accessor :source

  def initialize(source)
    self.source = source
  end

  def render(context)
    template = ::Liquid::Template.parse(self.source)
    template.render(context)
  end

end