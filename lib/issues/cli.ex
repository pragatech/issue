defmodule Issues.CLI do
  @default_count 4

  def run argv do
    parse_args argv
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_represntation
  end

  defp args_to_internal_represntation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end
  defp args_to_internal_represntation([user, project]), do: {user, project, @default_count}
  defp args_to_internal_represntation(_), do: :help
end
