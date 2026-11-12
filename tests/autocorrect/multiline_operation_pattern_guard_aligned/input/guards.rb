case value
in Integer unless Some::Long::Module::Name::Checker ===
                  value
  value
end

case value
in Integer if Some::Long::Module::Name::Checker ===
              value
  value
end

case value
in [a, b] if a == b &&
             c
  1
in ^(foo +
     bar) if x
  2
in Integer if foo.bar(a,
                      b)
  3
in String if foo
                .bar
                .baz
  4
in y if foo ||
  bar
  5
end
