class Life
  attr_reader :element
  def initialize(selector = 'body', parent = Element)
    @element = parent.find(selector)
    @controls = Controls.new('.controls', element)
    @saved_list = @element.find('.saved_list a').map do |element|
      SavedItem.new(element)
    end
    add_handlers!
    setup_grid!
  end

  def setup_grid!
    @cells = Hash[
      table_cells.collect do |table_cell|
        c = Cell.new(table_cell, table, width, height)
        [[c.x, c.y], c]
      end
    ]
  end

  def live_cells
    table_cells.filter('.live')
  end

  def live_cell_coordinates
    live_cells.map do |cell|
      [cell.data('x').to_i, cell.data('y').to_i]
    end
  end

  def live_cell_coordinate_list
    live_cell_coordinates.map do |coords|
      coords.join(',')
    end.join('|')
  end

  def cell(coords)
    integer_coords = coords.map(&:to_i)
    @cells[integer_coords]
  end

  def live_cells=(list)
    clear!
    cells = parse_coordinates(list).map { |c| cell(c) }
    cells.each do |c|
      c.set!
    end
  end

  def parse_coordinates(list)
    list.split('|').map {|c| c.split(',')}
  end

  def add_handlers!
    element.on 'life' do |_event, action|
      do_action(action)
    end

    element.on 'life:newinterval' do |_|
      restart_timer!
    end

    element.on 'loadset' do |_event, cellset|
      clear!
      self.live_cells = cellset
    end
  end

  def clear!
    all_cells.each(&:clear!)
  end

  def all_cells
    @cells.values
  end

  def do_action(action)
    case action
    when 'play'
      start_timer!
    when 'pause'
      stop_timer!
    when 'camera'
      snapshot!
    when 'clear'
      @controls.stop!
      clear!
    when 'reset'
      stop_timer!
      @controls.stop!
      all_cells.each(&:set_random!)
    end
  end

  def stop_timer!
    @timer.stop unless @timer.nil?
    @timer = nil
  end

  def restart_timer!
    if @timer
      start_timer!
    end
  end

  def start_timer!
    stop_timer!
    @timer = Interval.new(@controls.interval) do
      ticktock!
    end
  end

  def ticktock!
    all_cells.each(&:tick!)
    all_cells.each(&:tock!)
  end

  def snapshot!
    puts live_cell_coordinate_list
  end

  def width
    @width ||= table_cells.filter('[data-y=1]').size
  end

  def height
    @height ||= table_cells.filter('[data-x=1]').size
  end

  def table
    @table ||= element.find('table')
  end

  def table_cells
    @table_cells ||= table.find('td')
  end

  def button
    @button ||= element.find('a#button')
  end
end
