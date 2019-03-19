class SavedItem
  attr_reader :element, :parent
  def initialize(element)
    @element = element
    add_handlers!
  end

  def saved_set
    @element.data('set')
  end

  def add_handlers!
    element.on :click do
      element.trigger('loadset', saved_set)
    end
  end
end
