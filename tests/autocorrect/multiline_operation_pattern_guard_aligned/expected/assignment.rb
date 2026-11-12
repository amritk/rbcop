result = case value
         in Integer if Some::Long::Module::Name::Checker ===
                       value
           value
         in String unless foo &&
                          bar
           value
         end

result =
  case value
  in Integer if Some::Long::Module::Name::Checker ===
                value
    value
  end

@x ||= case value
       in Integer if foo
       .bar
         value
       end
