import Data.Char (digitToInt)
import Data.Foldable (maximumBy)
import Data.List (group, sort, transpose, sortOn)
import Data.Maybe (fromMaybe, listToMaybe)
import Numeric (readInt)
import qualified Data.Ord

main = do
  input <- readFile "./input.txt"
  let binaryInput = lines input

  let gamma = map mode $ transpose binaryInput
  print $ "gamma: " ++ gamma

  let epsilon = map (boolToChar . not . charToBool) gamma
  print $ "epsilon: " ++ epsilon

  let maybePowerConsumption = (*) <$> readBinary gamma <*> readBinary epsilon
  let powerConsumption = fromMaybe (error "error") maybePowerConsumption
  print $ "power consumption: " ++ show powerConsumption

  let o2GeneratorRating = singleBySuccessiveCriteria 0 (mostCommon '1') binaryInput
  print $ "o2 generator rating: " ++ o2GeneratorRating

  let co2ScrubberRating = singleBySuccessiveCriteria 0 (leastCommon '0') binaryInput
  print $ "co2 scrubber rating: " ++ co2ScrubberRating

  let maybeLifeSupportRating = (*) <$> readBinary o2GeneratorRating <*> readBinary co2ScrubberRating
  let lifeSupportRating = fromMaybe (error "error") maybeLifeSupportRating
  print $ "life support rating: " ++ show lifeSupportRating

-- I'm not happy with my understanding of all this code, or how clean it is, but it's time to move on to day 4.

mostCommon :: Ord a => a -> [a] -> a
mostCommon tieBreaker xs =
  let
    countedGroups = countGroups xs
    sortedGroups = sortOn (Data.Ord.Down . snd) countedGroups
    mostOccurrences = snd $ head sortedGroups
    largestGroups = filter (\(_, count) -> count == mostOccurrences) countedGroups
    mostCommon = case largestGroups of
      [x] -> fst x
      _ -> tieBreaker
  in mostCommon

leastCommon :: Ord a => a -> [a] -> a
leastCommon tieBreaker xs =
  let
    countedGroups = countGroups xs
    sortedGroups = sortOn snd countedGroups
    mostOccurrences = snd $ head sortedGroups
    largestGroups = filter (\(_, count) -> count == mostOccurrences) countedGroups
    mostCommon = case largestGroups of
      [x] -> fst x
      _ -> tieBreaker
  in mostCommon

singleBySuccessiveCriteria :: Ord a => Int -> ([a] -> a) -> [[a]] -> [a]
singleBySuccessiveCriteria _ _ [x] = x
singleBySuccessiveCriteria index getDesired xs = case listsWithEqualIndex desired index xs of
  [x] -> x
  xs -> singleBySuccessiveCriteria (index + 1) getDesired xs
  where
    desired = getDesired (transpose xs !! index)

listsWithEqualIndex :: Eq a => a -> Int -> [[a]] -> [[a]]
listsWithEqualIndex a index = filter indexEqual
  where
    indexEqual xs = xs !! index == a

readBinary :: Integral a => String -> Maybe a
readBinary = fmap fst . listToMaybe . readInt 2 (`elem` "01") digitToInt

mode :: (Ord a) => [a] -> a
mode xs = fst $ largestGroup $ countGroups xs

largestGroup :: (Foldable t, Ord a1) => t (a2, a1) -> (a2, a1)
largestGroup = maximumBy (\(_, a) (_, b) -> compare a b)

countGroups :: Ord a => [a] -> [(a, Int)]
countGroups xs = map (\xs -> (head xs, length xs)) $ group $ sort xs

charToBool '0' = False
charToBool _ = True

boolToChar False = '0'
boolToChar _ = '1'