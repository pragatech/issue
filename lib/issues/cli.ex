defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle command line parsing and dispatch
  to the various functions that end up generating
  tables for n_of_issues in a git hub project
  """
  def run argv do
    argv
    |> parse_args
    |> process
  end

  @doc """
  argv can have -h or --help, which return help

  otherwise, it will have github user name, project and no of issues count(optional)
  it returns, `{user, project,count}`
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_represntation
  end

  def process(:help) do
    IO.puts """
      usage: issues <user> <project> [count| #{@default_count}]
    """
    System.halt(0)
  end

  def process({user,project,_count}) do
    Issues.GithubIssues.fetch(user,project)
  end

  defp args_to_internal_represntation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end
  defp args_to_internal_represntation([user, project]), do: {user, project, @default_count}
  defp args_to_internal_represntation(_), do: :help
end
