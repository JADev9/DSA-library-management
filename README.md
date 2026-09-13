# DSA612S Assignment 1

## So what is this

Two systems, one repo.

The first one is for the Ministry of Higher Education — a library system. Books, laptops, labs, meeting rooms, anything the ministry owns across all the campuses. You can add stuff, look stuff up, loan it out, log work orders when something breaks. There's a REST API and a command-line client to poke at it.

The second one is for the Ministry of Tourism — a rental accommodation thing. Hosts list their places, guests browse and book them. That one's gRPC. Same deal: server and client.

Four folders:

- `library_api` — the REST backend, port 8080
- `library_client` — CLI for the above
- `rental_server` — the gRPC server, port 9090
- `rental_client` — gRPC client

## How to run it

Each folder is its own Ballerina package. Open a terminal in whichever one you want and `bal run`. For the client ones you'll need the server running somewhere else.

### Library

    cd library_api
    bal run

Different terminal:

    cd library_client
    bal run

Menu pops up, type a number, hit enter.

### Rentals

    cd rental_server
    bal run

Different terminal:

    cd rental_client
    bal run

This one just runs through everything in order and prints the results. No menu — it's a demo of every RPC.

## Q1 — the REST API

Everything hangs off `http://localhost:8080/library`.

| | | |
|---|---|---|
| POST | /assets | add an asset |
| GET | /assets | list all |
| GET | /assets/{tag} | get one |
| PUT | /assets/{tag} | update it |
| DELETE | /assets/{tag} | delete it |
| GET | /assets/overdue | what's overdue |
| GET | /institutions/{name}/assets?site= | filter by institution, optionally by site |
| POST | /assets/{tag}/components | add a component |
| DELETE | /assets/{tag}/components/{id} | remove a component |
| POST | /assets/{tag}/schedules | add a schedule |
| PUT | /assets/{tag}/schedules/{id} | change a schedule |
| DELETE | /assets/{tag}/schedules/{id} | remove a schedule |
| POST | /assets/{tag}/workorders | open a work order |
| PUT | /assets/{tag}/workorders/{oid} | change its status |
| POST | /assets/{tag}/workorders/{oid}/tasks | add a task |
| DELETE | /assets/{tag}/workorders/{oid}/tasks/{tid} | remove a task |
| POST | /assets/{tag}/loan | loan it out |
| POST | /institutions | add an institution |
| GET | /institutions | list them |
| PUT | /institutions/{id} | update one |
| DELETE | /institutions/{id} | remove one |

## Q2 — the gRPC side

Proto is in `rental_server/property.proto`. Service is called `RentalService`, port 9090.

| RPC | Type | Does |
|-----|------|------|
| add_property | simple | host adds a listing |
| update_property | simple | host edits it |
| remove_property | simple | host deletes it |
| search_property | simple | find by location |
| book_property | simple | guest adds to cart |
| confirm_booking | simple | guest finalizes |
| create_users | client stream | lots of users, one reply |
| list_available_properties | server stream | one request, lots of properties back |

## Why we did things the way we did

**Assets in a map keyed by assetTag.** Brief said Map or Table, assetTag as the key. Done.

**Institutions get their own map.** The brief says you should be able to add and remove institutions from listings — that only works if an institution is a thing on its own, not just a string sitting on an asset. So they get their own `map<Institution>` keyed by `institutionId`. You can't delete one while any asset still points at it.

**Work orders need a loop, not a filter.** When you remove a component or a schedule, you just rebuild the list without it, easy. But a task is inside a work order, which is inside an asset. You can't filter down to "the tasks in WO1" because you need to actually change that one work order, not replace a list. So we loop with an index, find it, and change it in place.

**Booking takes two steps.** `book_property` just checks the dates make sense and drops it in a cart (`bookingStore`). `confirm_booking` is the one that does the work — checks nobody's already booked those dates, works out the price (`pricePerNight × nights`), moves it to `confirmedBookings`, clears the cart. Two steps because you can't check for overlaps until you've got confirmed bookings to compare against.

## Who did what

- **Teclas (JADev9)** — set up the repo, built the Q1 REST API (asset CRUD, filtering, overdue), did `confirm_booking`, wrangled everyone's branches and merged the PRs.
- **Emanuel Macoquela** — `update_property`, `create_users`.
- **Helvi** — `remove_property`, `list_available_properties`.
- **RudgerKoyo (Coyo)** — `search_property` and the whole rental client.
- **Emilly Uutoni** — `book_property` and this README.
