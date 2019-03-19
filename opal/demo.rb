class Demo
  def initialize(selector)
    @demo = Element[selector]
    @input = @demo.find('input#say_something')
    @stats = @demo.find('p#stats')

    @input.on :keyup do |event|
      @stats.html = stats
    end
  end

  def stats
    "Vowels: #{vowels.size}, Consonants: #{consonants.size}"
  end

  def vowels
    characters.select { |l| is_a_vowel?(l) }
  end

  def consonants
    characters.reject { |l| is_a_vowel?(l) }
  end

  def is_a_vowel?(letter)
    %w(a e i o u).member? letter
  end

  def characters
    @input.value.downcase.chars.reject {|l| l == ' '}
  end
end
