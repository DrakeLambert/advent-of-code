record Command(Direction Direction, int Units)
{
    public static Command Parse(string command)
    {
        var parts = command.Split(" ");
        var direction = Enum.Parse<Direction>(parts[0], ignoreCase: true);
        int units = int.Parse(parts[1]);
        return new Command(direction, units);
    }
}

