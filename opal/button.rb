class Button
  attr_reader :element, :parent, :message
  def initialize(selector, parent, message, selected = false)
    @parent = parent
    @element = parent.find(selector)
    @selected = selected
    @message = message
    if selected
      select!
    end
    add_handlers!
  end

  def select!
    element.add_class('selected')
  end

  def deselect!
    element.remove_class('selected')
  end

  def add_handlers!
    element.on :click do
      parent.trigger('life', message)
    end
  end
end
