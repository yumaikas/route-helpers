(import err)

(def- route-args-patt 
  "Parse a route into segments"
  (peg/compile 
    ~{
      :route-lit (<- (some (* (if-not (set "/") 1))))
      :route-arg (<- (* ":" (some (if-not "/" 1))))
      :route-part (+ :route-arg :route-lit)
      :main (some (+ "/" :route-part)) }))

(defn- safe-string
  "Only turn values into a string/route parameter that can do so safely to"
  [val] 
  (cond
    (bytes? val) (string val)
    (int? val) (string val)
    (boolean? val) (string val)
    (err/str "Cannot safely convert a value of type " (type val) " to a string")))

(defn- parse-path-args 
  "Split a parsed roune into it's arguments and into a general template."
  [path] 
  (def route-segments (peg/match route-args-patt path))
  (unless route-segments 
    (err/str "Invalid route" path))

  {:args (as-> 
           route-segments it
           (filter |(do 
                      (string/has-prefix? ":" $)) it)
           (map |(slice $ 1) it))
   :template route-segments })

(defmacro- path-fn 
  "Create a helper function for constructing a route"
  [name path-spec] 
  ~(defn ,name ,(tuple/brackets ;(map symbol (path-spec :args)))
     (string "/" (string/join 
       ,(array ;(seq [el :in (path-spec :template)]
                 (cond 
                   (string/has-prefix? ":" el) ~(,safe-string ,(symbol (slice el 1)))
                   true (string el))))
       "/"))))
  
(defmacro def! 
  ```
  Declare a single route. This creates the route, but also creates a helper function that has NAME<- as it's name, and ensures the correct number of arguments
  ```
  [NAME PATH]
  (assert (= (type NAME) :symbol) 
          (string "NAME must be a symbol, not " NAME))
  (assert (= (type PATH) :string)
          (string "PATH must be a string, not " PATH))
  (def routespec (parse-path-args PATH))
  (def link-name (symbol NAME "<-"))
  ~(upscope 
     (def ,NAME ,PATH)
     ,(apply path-fn [link-name routespec])))

(defmacro routes
  ```
  Declare a set of routes using def!
  ```
  [& body] 
  (def route-pairs (partition 2 body))
  (assert (all |(= (length $) 2) route-pairs) 
          "Expected an even number of routes and strings")
  ~(upscope 
     ,;(seq [[NAME PATH] :in route-pairs]
         (apply def! [NAME PATH]))))

