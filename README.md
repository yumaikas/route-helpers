# router-helpers

## Example/Usage

Router-helpers is a very simple library: It gives you one level of indirection from writing raw URLs in your web apps, to allow your routes and generated links to be kept in sync without duplicated effort. It even allows the compiler to help you change your route names.

In your web application, create a `routes.janet`, and populate it using the following as an example:

```
(import route-helpers :as rt)

(r/routes 
  home "/"
  show-box "/box/:addr"
  send-to-box "/send/:addr"
  add-mailbox "/add-mailbox"
  poke-3d "/poke/:x/:y/:z"
  view-item "/message/:id")
```

Then, in your router, where routes are specificed, you can `(import ./routes.janet)`, you can use the name for the route (such as `routes/home`) as the string value for your router path. Below is an example in osprey.

```
(GET routes/home "Got to home!")
(GET routes/show-box (string "Viewing box " (params :addr)))
```

If you want to link to a given route, a helper function is created for each named route. It has the same name as the route, but ends with `<-`. So, for the show-box route above, we get:

```
(routes/show-box<- "@my-mailbox-address") # => "/box/@my-mailbox-address"
```

Helper functions are created analysing the path for a given route, and require enough arguments to populate all of the placeholders (path segments beginning with `:`) for a given path. So, if the `poke-3d<-` helper is called, it'll need 3 arguments, since the path given has 3 placeholders (`:x`, `:y` and `:z`).

```
(routes/poke-3d<- 1 2) # Results in a compile error
```

The helper function is pre-programmed to only display values in a URL-safe fashion, and will throw an error before it leaks debug objects into the URL.

## Status

Router-helpers might get expanded later, but is small enough in scope to be considered stable and useful as-is

## Install

`jpm install https://github.com/yumaikas/route-helpers` to install.

## Future

In the future, I might add a function call to allow auto-generating a JS clients from the definitions given here, but that is not yet.
