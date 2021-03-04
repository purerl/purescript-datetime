-module(data_dateTime@foreign).
-export([calcDiff/0, adjustImpl/4]).

rem1(X, R) -> case X rem R of
    0 -> R;
    N -> N
end.

createDateTime(Rec) ->
    #{ year := Y, month := Mo, day := D, hour := H, minute := M, second := S } = Rec,
    Mo1 = rem1(Mo,12),
    Y1 = Y + ((Mo - Mo1) div 12),
    YMDays = calendar:date_to_gregorian_days({Y1, Mo1, 1}),
    Days = YMDays + D - 1,
    Date = calendar:gregorian_days_to_date(Days),
    calendar:datetime_to_gregorian_seconds({Date,{H,M,S}}).

calcDiff() -> fun (Rec1,Rec2) ->
    #{ millisecond := MS1 } = Rec1,
    #{ millisecond := MS2 } = Rec2,
    float(1000 * (createDateTime(Rec1) - createDateTime(Rec2))
        + (MS1 - MS2))
end.

adjustImpl(Just,_Nothing,Offset,Rec) ->
    #{ millisecond := MS } = Rec,
    Secs1 = maps:get(second,Rec) + ((MS + round(Offset)) div 1000),
    AdjustedDT = createDateTime(Rec#{ second := Secs1 }),
    {{Y,Mo,D},{H,M,S}} = calendar:gregorian_seconds_to_datetime(AdjustedDT),
    Just(#{ year => Y, month => Mo, day => D, hour => H, minute => M, second => S, millisecond => ((MS + round(Offset)) rem 1000) }).
