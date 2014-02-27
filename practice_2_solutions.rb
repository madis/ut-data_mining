#!/usr/bin/env ruby
require_relative './homework_tools'
require 'mathn'

TRANSACTIONS_TABLE = [
  [1, 1234, %w{Aspirin, Panadol}],
  [1, 4234, %w{Aspirin Sudafed}],
  [2, 9373, %w{Tylenol Cepacol}],
  [2, 9843, %w{Aspirin Vitamin_C, Sudafed}],
  [3, 2941, %w{Tylenol Cepacol}],
  [3, 2753, %w{Aspirin Cepacol}],
  [4, 9643, %w{Aspirin Vitamin_C}],
  [4, 9691, %w{Aspirin Ibuprofen Panadol}],
  [5, 5313, %w{Panadol Vitamin_C}],
  [5, 1003, %w{Tylenol Cepacol Ibuprofen}],
  [6, 5636, %w{Tylenol Panadol Cepacol}],
  [6, 3478, %w{Panadol Sudafed Ibuprofen}]
]

Transaction = Struct.new(:customer, :transaction, :basket)

class Task1 < SimpleTask

  def initialize
    @transactions = TRANSACTIONS_TABLE.map {|t| Transaction.new(*t)}
  end

  def question
    parts = {
      a: "For the data from Table 1 compute the support and support count for itemsets {Aspirin}, {Tylenol, Cepacol}, {Aspirin, Ibuprofen, Panadol}.",
      b: "Compute the confidence for the following association rules: {Aspirin, Vitamin C} → {Sudafed}, {Aspirin} → {Vitamin C}, {Vitamin C} → {Aspirin}. Why the results for last two rules are different?",
      c: "List all the frequent itemsets if the support count threshold smin = 3.",
      d: "What does the anti-monotonicity property of support imply? Give anexample using the above data set."
    }
    parts.values.reduce {|s, t| s + "\n" + t }
  end

  def answer
    a + b
  end

  def a
    itemsets = [%w{Aspirin}, %w{Tylenol Cepacol}, %w{Aspirin Ibuprofen Panadol}]
    itemsets.map do |itemset|
      find_support itemset
    end
  end

  def b
    association_rules = {
      %w{Aspirin Vitamin_C} =>  %w{Sudafed},
      %w{Aspirin} => %w{Vitamin_C},
      %w{Vitamin_C} => %w{Aspirin}
    }
    support = association_rules.map do |from, to|
      rule_support = find_support from + to
      from_support = find_support from
      {
        {from => to} => rule_support[:support] / from_support[:support]
      }
    end
  end

  private

  def find_support(itemset)
    support_count = @transactions.count { |transaction| (itemset - transaction.basket).empty? }
    {
      itemset: itemset,
      support_count: support_count,
      support: support_count / @transactions.count
    }
  end
end

print_solution Task1
