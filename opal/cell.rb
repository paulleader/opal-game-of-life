class Cell
  attr_reader :table, :element
  def initialize(table_cell, table, width, height)
    @element = table_cell
    @width = width
    @height = height
    @table = table
    @stay_alive = nil
    neighbours
    attach_click_handler!
    @element.data('cell', self)
    @element.remove_class('waiting')
  end

  def attach_click_handler!
    element.on :click do
      @alive = !@alive
      set_cell!
    end
  end

  def set_random!
    @alive = (rand(2) == 1)
    set_cell!
  end

  def set!
    @alive = true
    set_cell!
  end

  def clear!
    @alive = false
    set_cell!
  end

  # Calculate the next state
  def tick!
    @stay_alive = next_state
  end

  def next_state
    live_neighbours == 3 or (@alive and live_neighbours == 2)
  end

  # Set the new state
  def tock!
    @alive = @stay_alive
    @stay_alive = nil
    set_cell!
  end

  def set_cell!
    if @alive
      element.add_class('live')
    else
      element.remove_class('live')
    end
  end

  def x
    @x ||= @element.data('x').to_i
  end

  def y
    @y ||= @element.data('y').to_i
  end

  def live_neighbours
    neighbours.filter('.live').size
  end

  def neighbours
    @neighbours ||= table.find(neighbour_selectors)
  end

  def neighbour_selectors
    neighbour_coordinates.map do |c|
      "td#x#{c.first}y#{c.last}"
    end.join(', ')
  end

  def wrapped_coordinates(x, y)
    ix = if (x == 0)
      @width
    elsif x > @width
      1
    else
      x
    end
    iy = if (y == 0)
      @height
    elsif y > @height
      1
    else
      y
    end
    [ix, iy]
  end

  def neighbour_coordinates
    [x-1, x, x+1]
      .product([y-1, y, y+1])
      .reject {|pair| (pair.first == x) && (pair.last == y) }
      .map do |pair|
        wrapped_coordinates(pair.first, pair.last)
    end
  end
end
