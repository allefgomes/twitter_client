defmodule TwitterClient do
  use Tesla

  @token System.get_env("TWITTER_TOKEN")

  plug(Tesla.Middleware.BaseUrl, "https://api.twitter.com")
  plug(Tesla.Middleware.DecodeJson)

  def get_twittes do
    {:ok, response} = make_request()

    twittes = response.body["statuses"]

    twittes
    |> create_presentations()
  end

  defp make_request do
    get("/1.1/search/tweets.json",
      query: [q: "elixir", count: 10],
      headers: [
        {"Authorization", "Bearer #{@token}"},
        {"Accept", "Application/json; Charset=utf-8"}
      ]
    )
  end

  defp create_presentations(twittes) do
    Enum.map(twittes, fn twitte -> print_twitte(twitte) end)

    %{message: "Thank you for watching!"}
  end

  defp print_twitte(tweet) do
    IO.puts("#{tweet["text"]}
    - Tweeted by #{tweet["user"]["name"]} at #{tweet["created_at"]} \n")
  end
end
