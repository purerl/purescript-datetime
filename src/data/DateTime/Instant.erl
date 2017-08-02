-module(data_dateTime_instant@foreign).
-export([fromDateTimeImpl/0, toDateTimeImpl/2]).

fromDateTimeImpl() -> fun (Y,Mo,D,H,M,S,MS) ->
    Secs = calendar:datetime_to_gregorian_seconds({{Y,Mo,D},{H,M,S}}),
    Epoch = calendar:datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}}),
    (Secs - Epoch) * 1000
end.

toDateTimeImpl(Ctor,Instant) ->
    Epoch = calendar:datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}}),
    Secs = Epoch + (Instant div 1000),
    {{Y,Mo,D},{H,M,S}} = calendar:gregorian_seconds_to_datetime(Secs),
    Ms = Instant rem 1000,
    ((((((Ctor(Y))(Mo))(D))(H))(M))(S))(Ms).
