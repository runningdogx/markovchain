#!/usr/bin/ruby

class MarkovLetters
  attr_accessor :minlength, :maxlength, :order

  def initialize
    # The idea is you have @seq['ab']['c'] represent the count of 'abc'
    # @seq['ab'][:sum] represents the sum of all ab<x>

    @seq = Hash.new {|h,k| h[k] = Hash.new {|h2,k2| h2[k2] = 0}}

    @a_minlen = 1000
    @a_maxlen = 0
    @minlength = nil
    @maxlength = nil

    @order = 2
  end

  def digest(word)
    expword = '#' * @order + word

    # add each n-gram
    @order.upto(expword.length - 1) do |i|
      wordprefix = expword[i-@order,@order]
      wordtarget = expword[i]
      @seq[wordprefix][wordtarget] += 1
      @seq[wordprefix][:sum] += 1
    end
    @a_minlen = word.length if word.length < @a_minlen
    @a_maxlen = word.length if word.length > @a_maxlen
  end

  def pick_next(leader)
    hash = @seq[leader]
    if hash[:sum] == 0
      hash = @seq['#' * @order]
      if hash[:sum] == 0
        return '#'
      end
    end

    target = rand(hash[:sum])
    hash.reject{|k,v| k==:sum}.each_pair do |k,v|
      target -= v
      return k if target < 0
    end
  end

  def pick_length
    min = @minlength || @a_minlen
    max = @maxlength || @a_maxlen
    rand(max - min + 1) + min
  end

  def generate(prefix = '')
    extra = 0
    if prefix.length < @order
      extra = @order - prefix.length
      word = '#' * extra + prefix
    else
      word = prefix
    end

    addcount = pick_length - prefix.length
    addcount.times do
      word += pick_next(word[-@order..-1])
    end

    extra == 0 ? word : word[extra..-1]
  end

  def status(type='#'*@order)
    # half baked
    puts "Minimum length: #{@minlength || @a_minlen}"
    puts "Maximum length: #{@maxlength || @a_maxlen}"
    puts @seq[type].reject{|k,v| k==:sum}

    puts "Number of keys: #{@seq.keys.size}"
    puts @seq.keys
  end
end

