import Data.Maybe (fromJust, isNothing)
import Text.Read (readMaybe)

main = do
  input <- lines <$> readFile "./input.txt"

  let drawnNumbers = inputToDrawnNumbers input

  print drawnNumbers

  let boards = inputToBoards input

  print boards

inputToDrawnNumbers :: [String] -> [Int]
inputToDrawnNumbers xs =
  let firstLine = head xs
      numbers = splitString ',' firstLine
   in map read numbers

inputToBoards :: [String] -> [Board]
inputToBoards [] = []
inputToBoards (x : xs)
  | ',' `elem` x = next
  | x == "" = next
  | otherwise = stringsToBoard currentBoardStrings : inputToBoards dropFive
  where
    next = inputToBoards xs
    currentBoardStrings = x : take 4 xs
    dropFive = drop 4 xs

newtype Row = Row [Int]

instance Show Row where
  show (Row numbers) = show numbers

stringToRow :: String -> Row
stringToRow xs
  | length numbers /= 5 = error "string must contain exactly 5 numbers"
  | otherwise = Row numbers
  where
    numbers = map read (words xs)

newtype Board = Board [Row]

instance Show Board where
  show (Board rows) = show rows

stringsToBoard :: [String] -> Board
stringsToBoard xs
  | length xs /= 5 = error "list must contain exactly 5 strings"
  | otherwise = Board (map stringToRow xs)

splitString :: Char -> String -> [String]
splitString _ "" = [[]]
splitString separator (x : xs) =
  let next = splitString separator xs
   in if x == separator
        then "" : next
        else (x : head next) : tail next

joinStrings :: String -> [String] -> String
joinStrings _ [] = ""
joinStrings _ [x] = x
joinStrings separator (x : xs) = x ++ separator ++ joinStrings separator xs