{ lib, utils, ... }:
let
  inherit (builtins) length head;
  inherit (lib.trivial) throwIf;
  inherit (lib.strings) concatStrings;
  inherit (lib.lists) foldr last range;
  inherit (utils.networking) splitWhen;
in
{

  /**
    # Description

    Generates inclusive portrange given a lower and a higher number,
    additionally throws an error if the end of the range is not strictly
    greater.

    # Type

    ```
    utils.networking.portrange :: Int -> Int -> [ Int ]
    ```
  */
  rangeToPorts = from: to:
    let ports = range from to;
    in throwIf (length ports == 0)
      (concatStrings [
        "the second input has to be larger then the first one, "
        "otherwise you have a negative range which is impossible "
        "or not a range."
      ])
      ports;

  /**
    # Example

    ```nix
    let formatRange = { start, end }: "${toString start}-${toString end}"
    in map (x: if isAttrs x then formatRange x else x)
       (portsToRanges [ 1 2 3 ])
    => [ "1-3" ]
    ```

    # Type

    ```
    utils.networking.portsToRanges :: [Int] -> [Int + { start end :: Int }]
    ```
  */
  portsToRanges = ports:
    let
      partitioned = splitWhen (a: b: a + 1 == b) ports;
      format = range:
        if length range == 1
        then head range
        else { start = head range; end = last range; };
    in
    map format partitioned;

  /**
    # Example

    ```nix
    # split into strictly ordered sublists
    splitWhen (a: b: a < b) [ 7 8 9 4 5 6 1 2 3 ]
    => [ [ 7 8 9 ] [ 4 5 6 ] [ 1 2 3 ] ]
    ```

    # Type

    ```
    utils.networking.splitWhen :: (a -> a -> Bool) -> [a] -> [[a]]
    ```
  */
  splitWhen = p: xs:
    let
      unfold = { xs, xss }:
        if length xs == 0 then xss else [ xs ] ++ xss;

      addElement = x: { xs, xss }:
        if length xs == 0
        then { xs = [ x ]; inherit xss; }
        else if p x (head xs)
        then { xs = [ x ] ++ xs; inherit xss; }
        else { xs = [ x ]; xss = [ xs ] ++ xss; };
    in
    unfold (foldr addElement { xs = [ ]; xss = [ ]; } xs);

}
