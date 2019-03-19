class Controls
  attr_reader :element
  def initialize(selector, parent)
    @element = parent.find(selector)
    @start_stop = PlayPauseControl.new('a.button#playpause', element)
    @clear = Button.new('a.button#clear', element, 'clear')
    @reset = Button.new('a.button#reset', element, 'reset')
    @camera = Button.new('a.button#camera', element, 'camera')
    @speed_control = SpeedControl.new('.speed_control', element)
  end

  def interval
    @speed_control.interval
  end

  def stop!
    @start_stop.stop!
  end

  def start!
    @start_stop.stop!
  end
end
