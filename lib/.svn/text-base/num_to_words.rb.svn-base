module NumWords
  Numbers = {
      1 => 'one',
      2 => 'two',
      3 => 'three',
      4 => 'four',
      5 => 'five',
      6 => 'six',
      7 => 'seven',
      8 => 'eight',
      9 => 'nine',
      10 => 'ten',
      11 => 'eleven',
      12 => 'twelve',
      13 => 'thirteen',
      14 => 'fourteen',
      15 => 'fifteen',
      16 => 'sixteen',
      17 => 'seventeen',
      18 => 'eighteen',
      19 => 'nineteen',
      20 => 'twenty',
      30 => 'thirty',
      40 => 'forty',
      50 => 'fifty',
      60 => 'sixty',
      70 => 'seventy',
      80 => 'eighty',
      90 => 'ninety'
  }

  AmExponents = {
      3 => 'thousand',
      6 => 'million',
      9 => 'billion',
      12 => 'trillion',
      15 => 'quadrillion',
      18 => 'quintillion',
      21 => 'sexillion',
      24 => 'septillion',
      27 => 'octillion',
      30 => 'nonillion',
      33 => 'decillion',
      36 => 'undecillion',
      39 => 'duodecillion',
      42 => 'tredecillion',
      45 => 'quattuordecillion',
      48 => 'quindecillion',
      51 => 'sexdecillion',
      54 => 'septendecillion',
      57 => 'octodecillion',
      60 => 'novemdecillion',
      63 => 'vigintillion',
      66 => 'unvigintillion',
      69 => 'duovigintillion'
  }

  EurExponents = {
      3 => 'thousand',
      6 => 'million',
      9 => 'milliard',
      12 => 'billion',
      15 => 'billiard',
      18 => 'trillion',
      21 => 'trilliard',
      24 => 'quadrillion',
      27 => 'quadrilliard',
      30 => 'quintillion',
      33 => 'quintilliard',
      36 => 'sextillion',
      39 => 'sextilliard',
      42 => 'septillion',
      45 => 'septilliard',
      48 => 'octillion',
      51 => 'octilliard',
      54 => 'noventillion',
      57 => 'noventilliard',
      60 => 'decillion',
      63 => 'decilliard',
      66 => 'undecillion',
      69 => 'undecilliard'
  }

  Max_exponent = 69

  def self.to_English_base(val, include_and = false)

    result = ''

    sep = include_and ? ' and ' : ' ';

    if val >= 100 then
      v1 = val / 100
      result << ' ' << Numbers[v1] << ' hundred'
      val -= v1 * 100
    end

    if val >= 20 then
      v1 = val / 10
      result << sep << Numbers[v1 * 10]
      val -= v1 * 10
      sep = ' '
    end

    if val > 0 then
      result << sep << Numbers[val]
    end

    result.capitalize
  end
  
  def self.to_English(val, eu_names = true, include_and = true)
    val = val.abs.round
    return "zero" if val == 0
    include_and = false if val <= 100
    exp_hash = eu_names ? EurExponents : AmExponents
    a = []
    (a.push val % 1000 ; val /= 1000) while val > 0
    r = ''
    if a[1] == 1 and a[0] >= 100 then
      a[1] = 0
      a[0] += 1000
    end
    
    #puts a.to_yaml
    a.each_with_index {|obj,i|
      next if obj == 0
      r = "#{to_English_base(obj, include_and && i == 0)} #{exp_hash[i*3]}".strip.capitalize + " #{r}"
    }
    r.strip
  end

  def self.to_American(val, include_and = true)
    to_English(val, false, include_and)
  end

  def to_english
    number = self
    NumWords.to_American(number)
  end
end

Fixnum.send(:include, NumWords)
Float.send(:include, NumWords)
Integer.send(:include, NumWords)