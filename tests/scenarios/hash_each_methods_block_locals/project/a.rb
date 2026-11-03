# frozen_string_literal: true

foo.each do |x; y|
  bar(x)
end
foo.each { |x; y| y = 1; bar(y) }
foo.each { |; a, b| bar(a) }
foo.each { |; a, b| bar }
foo.each { |k, v; z| bar(k) }
foo.each { |x; y| bar(x, y) }
