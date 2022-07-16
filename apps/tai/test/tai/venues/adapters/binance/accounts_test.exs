defmodule Tai.Venues.Adapters.Binance.AccountsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @venue Tai.TestSupport.Helpers.test_venue_adapter(:binance)

  setup_all do
    HTTPoison.start()
    :ok
  end

  test "returns an error tuple when the secret is invalid" do
    use_cassette "venue_adapters/shared/accounts/binance/error_invalid_secret" do
      assert {:error, {:credentials, reason}} = Tai.Venues.Client.accounts(@venue, :main)
      assert reason == "API-key format invalid."
    end
  end

  test "returns an error tuple when the api key is invalid" do
    use_cassette "venue_adapters/shared/accounts/binance/error_invalid_api_key" do
      assert {:error, {:credentials, reason}} = Tai.Venues.Client.accounts(@venue, :main)
      assert reason == "API-key format invalid."
    end
  end

  test "returns an error tuple when the request times out" do
    use_cassette "venue_adapters/shared/accounts/binance/error_timeout" do
      assert Tai.Venues.Client.accounts(@venue, :main) == {:error, :timeout}
    end
  end

  test "returns an error tuple when the timestamp of the local machine is outside the Binance receive window" do
    use_cassette "venue_adapters/shared/accounts/binance/error_timestamp_outside_recv_window" do
      assert Tai.Venues.Client.accounts(@venue, :main) == {:error, :receive_window}
    end
  end
end
