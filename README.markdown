# Markov word generator in ruby.

Usage: ./markovchain.rb -h
Usage: ./markovletters.rb -h

The first is slightly slower, but the markov class is generic enough to use for
more than text characters.

The two data/dist.gender.first files are from the 2000 U.S. Census.


## Examples

10 male names each starting with the letter 'T' or 'M'

cat data/dist.male.first | ./markovchain.rb T M


20 6- and 7- character female names starting with the letter 'A'

cat data/dist.female.first | ./markovchain.rb --minlen 6 --maxlen 7 -n 20 A


10 5-letter names using 3rd-order markov chain

cat data/dist.\*.first | ./markovchain.rb --order 3 --length 5

