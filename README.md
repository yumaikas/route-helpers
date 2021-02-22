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
  view-item "/message/:id")
```

Then, in your router, where routes are specificed, you can `(import ./routes.janet)`, use `routes/home` as the string value (shown below, assuming osprey).

```
(GET routes/home "Got to home!")
(GET routes/show-box (string "Viewing box " (params :addr)))
```

If you want to create a link to a string, then you can use a helper:

```
(routes/show-box<- "@my-mailbox-address")
```

The helper function is pre-programmed to only display values in a URL-safe fashion, and will throw an error before it leaks debug objects into the URL.

## Status

Router-helpers might get expanded later, but is small enough in scope to be considered stable and useful as-is

## Install

`jpm install https://github.com/yumaikas/route-helpers` to install.

## Future

In the future, I might add a function call to allow auto-generating a JS clients from the definitions given here, but that is not yet.
