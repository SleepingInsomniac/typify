class Typify
  
  VOWELS = "aeiou"
  CONSONANTS = ("a".."z").reject {|l| VOWELS.include? l }.join
  SAMPLE_TEXT = <<-EOF
    Randomness means lack of pattern or predictability in events.[1] Randomness suggests a non-order or non-coherence in a sequence of symbols or steps, such that there is no intelligible pattern or combination.
    Random events are individually unpredictable, but the frequency of different outcomes over a large number of events (or "trials") are frequently predictable. For example, when throwing two dice and counting the total, a sum of 7 will randomly occur twice as often as 4, but the outcome of any particular roll of the dice is unpredictable. This view, where randomness simply refers to situations where the certainty of the outcome is at issue, applies to concepts of chance, probability, and information entropy. In these situations, randomness implies a measure of uncertainty, and notions of haphazardness are irrelevant.
    The fields of mathematics, probability, and statistics use formal definitions of randomness. In statistics, a random variable is an assignment of a numerical value to each possible outcome of an event space. This association facilitates the identification and the calculation of probabilities of the events. A random process is a sequence of random variables describing a process whose outcomes do not follow a deterministic pattern, but follow an evolution described by probability distributions. These and other constructs are extremely useful in probability theory.
    Randomness is often used in statistics to signify well-defined statistical properties. Monte Carlo methods, which rely on random input, are important techniques in science, as, for instance, in computational science.[2]
    Random selection is a method of selecting items (often called units) from a population where the probability of choosing a specific item is the proportion of those items in the population. For example, if we have a bowl of 100 marbles with 10 red (and any red marble is indistinguishable from any other red marble) and 90 blue (and any blue marble is indistinguishable from any other blue marble), a random selection mechanism would choose a red marble with probability 1/10. Note that a random selection mechanism that selected 10 marbles from this bowl would not necessarily result in 1 red and 9 blue. In situations where a population consists of items that are distinguishable, a random selection mechanism requires equal probabilities for any item to be chosen. That is, if the selection process is such that each member of a population, of say research subjects, has the same probability of being chosen then we can say the selection process is random.
  EOF
  
  def initialize(words = SAMPLE_TEXT)
    @mapping = sample_words words
  end
  
  attr_accessor :mapping
  
  def sample_words(words = SAMPLE_TEXT)
    @mapping           ||= Hash.new
    @mapping[:chars]   ||= Hash.new
    @mapping[:starts]  ||= Hash.new
    @mapping[:lengths] ||= Array.new
    ("a".."z").each { |l| mapping[:chars][l] = "" }
    words = words.downcase.split(/[^a-z]+/)
    
    words.each do |w|
      next if w.length == 0
      @mapping[:lengths] << w.length
      @mapping[:starts][w.length] ||= ""
      @mapping[:starts][w.length] << w[0].to_s if w
      w.length.times do |i|
        @mapping[:chars][w[i]] << w[i+1] if w[i+1]
      end
    end
    
    return @mapping
  end
  
  def random(length = @mapping[:lengths].sample)
    word = String.new
    word << @mapping[:starts][length].split('').sample
    length.times do |l|
      begin
        word << @mapping[:chars][word[l]].split('').sample
      rescue
        # there was no mapping here
      end
    end
    word
  end
  
  def make(length = rand(7..50))
    words = Array.new
    length.times { words << random }
    words
  end
  
end

# List of sample words is analyzed for frequency of next letter occurance..
# generates a probability for what the next letter should be. 
# Pick a random letter based on that probability. 