class Features < Struct.new(:outlook, :temp, :humidity, :wind)
end

class Example < Struct.new(:features, :result)
end

p = Features.new(:sunny, :hot, :high, false)
DATA = {
  [:sunny, :hot, :high, false] => :no,
  [:sunny, :hot, :high, true] => :no,
  [:overcast, :hot, :high, false] => :yes,
  [:rainy, :mild, :high, false] => :yes,
  [:rainy, :cool, :normal, false] => :yes,
  [:rainy, :cool, :normal, true] => :no,
  [:overcast, :cool, :normal, true] => :yes,
  [:sunny, :mild, :high, false] => :no,
  [:sunny, :cool, :normal, false] => :yes,
  [:rainy, :mild, :normal, false] => :yes,
  [:sunny, :mild, :normal, true] => :yes,
  [:overcast, :mild, :high, true] => :yes,
  [:overcast, :hot, :normal, false] => :yes,
  [:rainy, :mild, :high, true] => :no
}

# windy and sunny today, temperature is cold and humidity is high.
