var input = File.ReadAllLines("./input.txt");

var commands = input.Select(line => Command.Parse(line));

static int GetDiagonalDistance(IEnumerable<Command> commands)
{
    var horizontalDistance = 0;
    var depth = 0;

    foreach (var command in commands)
    {
        switch (command.Direction)
        {
            case Direction.Forward:
                horizontalDistance += command.Units;
                break;
            case Direction.Down:
                depth += command.Units;
                break;
            case Direction.Up:
                depth -= command.Units;
                break;
        }
    }

    return horizontalDistance * depth;
}

Console.WriteLine($"Diagonal distance: {GetDiagonalDistance(commands)}");


static int GetDiagonalDistanceWithAim(IEnumerable<Command> commands)
{
    var horizontalDistance = 0;
    var depth = 0;
    var aim = 0;

    foreach (var command in commands)
    {
        switch (command.Direction)
        {
            case Direction.Forward:
                horizontalDistance += command.Units;
                depth += aim * command.Units;
                break;
            case Direction.Down:
                aim += command.Units;
                break;
            case Direction.Up:
                aim -= command.Units;
                break;
        }
    }

    return horizontalDistance * depth;
}

Console.WriteLine($"Diagonal distance with aim: {GetDiagonalDistanceWithAim(commands)}");
