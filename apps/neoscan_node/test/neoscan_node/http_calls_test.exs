defmodule Neoscan.HttpCalls.HttpCallsTest do
  use ExUnit.Case

  alias NeoscanNode.HttpCalls
  import ExUnit.CaptureLog

  @node_url "http://seed1.cityofzion.io:8080"
  @token_url "http://notifications1.neeeo.org/v1/tokens"

  test "request/3" do
    data = "{\"params\":[0,1],\"method\":\"getblock\",\"jsonrpc\":\"2.0\",\"id\":5}"
    headers = [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]
    assert {:ok, _} = HttpCalls.request(headers, data, @node_url)

    assert capture_log(fn -> assert :ok == HttpCalls.request(headers, data, 123) end) =~
             "Error in url"

    data = "{\"params\":[0,1],\"method\":\"getblockerror\",\"jsonrpc\":\"2.0\",\"id\":5}"
    assert {:error, _} = HttpCalls.request(headers, data, @node_url)
  end

  test "get/3" do
    assert {:ok, [_ | _], _} = HttpCalls.get(@token_url)
    assert capture_log(fn -> assert :ok == HttpCalls.get(123) end) =~ "Error in url"

    assert capture_log(fn -> assert {:error, ":error error"} == HttpCalls.get("error") end) =~
             ":error error"
  end
end