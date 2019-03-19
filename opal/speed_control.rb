class SpeedControl
  attr_reader :container, :value_field
  def initialize(selector, parent)
    @container = parent.find(selector)
    @value_field = container.find('input#interval')
    @faster_button = container.find('#faster')
    @slower_button = container.find('#slower')
    add_handlers!
  end

  def add_handlers!
    @faster_button.on :click do
      up!
      container.trigger('life:newinterval')
    end

    @slower_button.on :click do
      down!
      container.trigger('life:newinterval')
    end
  end

  def value
    @value_field.value.to_f
  end

  def interval
    1000 / value
  end

  def up!
    @value_field.value = value + 1
  end

  def down!
    @value_field.value = value - 1 if value > 1
  end
end
