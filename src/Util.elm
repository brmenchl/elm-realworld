module Util exposing (find)


find : (a -> Bool) -> List a -> Maybe a
find pred =
    List.head << List.filter pred
