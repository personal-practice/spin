byte arbitrary;

chan link = [2] of {byte} ;

proctype sender(chan c) {
  byte x = 0 ;
  do /* repeat forever */
  :: printf("Sending %u\n", x) ; c!x ; x = (x+1)%4 ;
  od ;
}

proctype receiver(chan c) {
  byte r ;
  byte trash ;
  bool corrupt = false ;
  do /* repeat forever */
  :: c?r     -> corrupt = false ; printf("Receiving %u\n", r) ;
  :: c?trash -> corrupt = true  ; printf("CORRUPTED\n") ; (false) ;
  od ;
}

init {
  // Increment 'arbitrary' a random number of times
  do
    :: arbitrary = arbitrary + 1
    :: break
  od
  run sender(link) ;
  run receiver(link) ;
}

ltl non_valid {
  [] ((sender:x == 0) -> <> (receiver:r == 0))
}
ltl valid {
  [] ((sender:x == 0) -> <> (receiver:corrupt || receiver:r == 0))
}
ltl valid_general {
  [] ((sender:x == arbitrary) -> <> (receiver:corrupt || receiver:r == arbitrary))
}
