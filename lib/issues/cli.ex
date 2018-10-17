defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_table_for_columns: 2]
  @default_count 4

  @moduledoc """
  Handle command line parsing and dispatch
  to the various functions that end up generating
  tables for n_of_issues in a git hub project
  """
  def main argv do
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

  def process({user,project,count}) do
    Issues.GithubIssues.fetch(user,project)
    |> decode_response
    |> sort_into_descending_order
    |> last(count)
    |> print_table_for_columns(["number","created_at", "title"])
  end

  def sort_into_descending_order list_of_issues do
    list_of_issues
    |> Enum.sort(fn i1,i2 -> i1["created_at"] >= i2["created_at"] end)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, error}) do
    IO.puts "Error fetching from Github: #{error["message"]}"
    System.halt(2)
  end

  defp args_to_internal_represntation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end
  defp args_to_internal_represntation([user, project]), do: {user, project, @default_count}
  defp args_to_internal_represntation(_), do: :help
end
