#!/usr/bin/ruby

class MarkovChain
  attr_accessor :minlength, :maxlength, :order

  def initialize
    # The idea is @seq[[a,b,c]][d] represents frequency of that 4-gram
    # and @seq[[a,b,c]][:sum] represents sum of all 4-grams starting
    # [a,b,c]

    @seq = Hash.new {|h,k| h[k] = Hash.new {|h2,k2| h2[k2] = 0}}

    @a_minlen = 1000
    @a_maxlen = 0
    @minlength = nil
    @maxlength = nil

    @order = 2
  end

  def digest(chain)
    expchain = [nil]*@order + chain

    # add each n-gram
    @order.upto(expchain.length - 1) do |i|
      chainprefix = expchain[i-@order,@order]
      chaintarget = expchain[i]
      @seq[chainprefix][chaintarget] += 1
      @seq[chainprefix][:sum] += 1
      #puts "added markov chain #{expchain[i-@order,@order]} => #{expchain[i]}"
    end

    # adjust automatic min and max chain lengths
    @a_minlen = chain.length if chain.length < @a_minlen
    @a_maxlen = chain.length if chain.length > @a_maxlen
  end

  def pick_next(leader)
    hash = @seq[leader]
    if hash[:sum] == 0
      hash = @seq[[nil] * @order]
      if hash[:sum] == 0
        return nil
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

  def generate(prefix = [])
    chain = prefix.dup
    nils = 0
    if chain.size < @order
      nils = @order - chain.size
      chain.unshift(*[nil]*(nils))
    end

    addcount = pick_length - prefix.length
    addcount.times do
      chain.push pick_next(chain[-@order..-1])
    end

    nils == 0 ? chain : chain[nils..-1]
  end

  def status(type=[nil]*@order)
    # half baked
    puts "Minimum length: #{@minlength || @a_minlen}"
    puts "Maximum length: #{@maxlength || @a_maxlen}"
    puts @seq[type].reject{|k,v| k==:sum}

    puts "Number of keys: #{@seq.keys.size}"
    puts @seq.keys.map {|key| key.map{|k| k==nil ? '-' : k}.join('')}
  end
end

