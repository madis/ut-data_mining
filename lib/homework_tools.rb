require 'prettyprint'

class Printer
  def self.print(content)
    puts content
  end
end

def print_solution(task)
  task.call Printer
end

class SimpleTask
  def self.call(printer)
    task = new
    printer.print("Question:")
    printer.print(task.question)
    printer.print("Answer:")
    printer.print(task.answer)
  end
end
