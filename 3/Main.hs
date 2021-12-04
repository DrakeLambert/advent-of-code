import Data.List ( transpose, sort, group )
import Data.Maybe (listToMaybe)
import Numeric (readInt)
import Data.Char (digitToInt)
import Data.Foldable (maximumBy)

main = do
  input <- readFile "./input.txt"
  let binaryInput = split '\n' input

  let gamma = map mode $ transpose binaryInput
  print $ "gamma: " ++ gamma

  let epsilon = map (boolToChar . not . charToBool) gamma
  print $ "epsilon: " ++ epsilon

  print $ (*) <$> readBinary gamma <*> readBinary epsilon

readBinary :: Integral a => String -> Maybe a
readBinary = fmap fst . listToMaybe . readInt 2 (`elem` "01") digitToInt

mode :: (Ord a) => [a] -> a
mode xs = fst $ largestGroup $ countedGroups xs
  where
    countedGroups xs = map (\xs -> (head xs, length xs)) $ group $ sort xs
    largestGroup xs = maximumBy (\(_, a) (_, b) -> compare a b) xs

split :: Char -> [Char] -> [[Char]]
split _ "" = [""]
split delimiter (x : xs)
  | x == delimiter = "" : rest
  | otherwise = (x : head rest) : tail rest
  where
    rest = split delimiter xs

charToBool '0' = False
charToBool _ = True

boolToChar False = '0'
boolToChar _ = '1'