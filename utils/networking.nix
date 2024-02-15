{ lib, ... }: {
  networking = {
    /*
      Generates inclusive portrange given a lower and a higher number

      Type:
        utils.networking.portrange:: Int -> Int -> [ Int ]
    */
    portrange =
      from:
      to:
      let
        helper = input:
          if input.counter >= 0 then
            helper
              {
                list = [ (from + input.counter) ] ++ input.list;
                counter = input.counter - 1;
              } else input.list;
      in
      lib.throwIf (from > to) "the second input has to be larger then the first one, otherwise you have a negative range which is impossible or not a range."
        helper
        { list = [ ]; counter = to - from; }
    ;
  };
}
