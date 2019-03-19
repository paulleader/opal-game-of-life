class PlayPauseControl
  attr_reader :element, :parent, :playing
  def initialize(selector, parent, playing = false)
    @parent = parent
    @element = parent.find(selector)
    @playing = playing
    set_label!
    add_handlers!
  end

  def set_label!
    @element.html = if @playing
      element.add_class('selected')
      "<i class='fa fa-pause'></i>"
    else
      element.remove_class('selected')
      "<i class='fa fa-play'></i>"
    end
  end

  def start!
    @playing = true
    set_label!
  end

  def stop!
    @playing = false
    set_label!
  end

  def event_message
    @playing ? 'play' : 'pause'
  end

  def send_event!
    puts "Send event #{event_message}"
    parent.trigger('life', event_message)
  end

  def toggle!
    @playing = !@playing
    set_label!
    send_event!
  end

  def add_handlers!
    element.on :click do
      toggle!
    end
  end
end
