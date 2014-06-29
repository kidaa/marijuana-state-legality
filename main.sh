ruby ./src/geo_separate.rb --d $1
ruby ./src/word_freq_by_state.rb --d $1
ruby ./src/legality-vs-states.rb --d $1
python ./src/legality-vs-states.py 