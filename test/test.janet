# Tests for router-helpers
(use testament)
(import ../route-helpers :as rt)


(rt/routes
  home "/"
  box "/box/:addr"
  send-item "/send/:addr"
  poke-3d "/poke/:x/:y/:z"
  add-mailbox "/add-mailbox")

(exercise! 
  []

  (deftest helpers-work
    (assert-equal "/" (home<-))
    (assert-equal "/box/@calendar" (box<- "@calendar"))
    (assert-equal "/poke/1/2/3" (poke-3d<- 1 2 3))
    (assert-equal "/send/@calendar" (send-item<- "@calendar")))

  (deftest values-work 
    (assert-equal "/" home)
    (assert-equal "/box/:addr" box)))



