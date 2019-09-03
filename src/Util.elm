module Util exposing (andThen)

import List


andThen : List a -> (a -> List b) -> List b
andThen =
    flip List.concatMap


flip : (a -> b -> c) -> b -> a -> c
flip f x y =
    f y x
