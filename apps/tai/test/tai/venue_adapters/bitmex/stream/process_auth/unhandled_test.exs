defmodule Tai.VenueAdapters.Bitmex.Stream.ProcessAuth.UnhandledTest do
  use Tai.TestSupport.DataCase, async: false
  import Tai.TestSupport.Assertions.Event
  alias Tai.VenueAdapters.Bitmex.Stream.ProcessAuth

  @venue :venue_a
  @credential {:main, %{}}
  @received_at Tai.Time.monotonic_time()

  setup do
    start_supervised!({ProcessAuth, [venue: @venue, credential: @credential]})
    :ok
  end

  test "processes the message from the venue" do
    TaiEvents.firehose_subscribe()

    @venue
    |> ProcessAuth.process_name()
    |> GenServer.cast({%{"table" => "unknown"}, @received_at})

    assert_event(%Tai.Events.StreamMessageUnhandled{} = unhandled_event, :warning)
    assert unhandled_event.venue_id == @venue
    assert unhandled_event.msg == %{"table" => "unknown"}
    assert %DateTime{} = unhandled_event.received_at
  end
end
