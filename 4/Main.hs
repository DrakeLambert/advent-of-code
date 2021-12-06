main = do
  input <- lines <$> readFile "./input.txt"

  let drawnNumbers = split ',' (head input)

  print drawnNumbers

split :: Char -> String -> [String]
split _ "" = [[]]
split separator (x : xs) =
  let next = split separator xs
   in if x == separator
        then "" : next
        else (x : head next) : tail next
