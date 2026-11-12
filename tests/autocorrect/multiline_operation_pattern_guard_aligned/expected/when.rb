case value
when Some::Long::Module::Name::Checker ===
  value
  value
when foo &&
  bar
  value
end

case
when foo ||
  bar
  1
when baz +
  qux
  2
end

x = case value
    when foo &&
         bar
      1
    end
