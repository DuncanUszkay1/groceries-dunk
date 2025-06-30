# Discussion

This doc is here to highlight any of the non-trivial choices made in developing this app.

## Rest API

The API exposes 6 post operations:
```
post 'list_item/add_to_list'
post 'list_item/mark_purchased'
post 'list_item/edit_name'
post 'list_item/delete'
post 'list_item/mark_all_as_purchased'
post 'list_item/delete_all'
```

There certainly are simpler expressions of this API- it could even be as simple as a single bulk 'create or update' operation.
I opted against that route and toward the route of having small, purpose-focused endpoints for the following reasons:
- By not enabling all possible functionality at the onset, it forces a moment of consideration before the feature is added- should we allow this? Will this cause issues?
- In a future implementation, we could imagine that these operations may have differenet expectations in terms of latency, timeline for eventual consistency, permissions, and so on. This approach will make it easy to have that fine grained level of control as those requirements deviate.

## LineItem API

The LineItem class derives from the ActiveRecord::Base class, which exposes a wide array of DB operations that would be easily sufficient to support our API endpoints. I've opted to not use those from the controller. In my time writing Rails applications, I've found that DB accesses through ActiveRecord outside of that record's scope to be a common cause for expensive and complex bugs, both because it can make migration to a new model more challenging, and because it's easy to misinterpret data read directly from the DB.

As an example, suppose we were to add a search feature. If the implementor of this feature was unfamiliar with the data model, they might write code like this:
```
ListItem.where("name like ?", "%#{name}%")
```
This will pass their tests, but since there's no index on the field it could cause issues when used in practice.

To avoid this class of errors, I like to create class methods on a per-use case basis on the model in question. Of course, the implementor could still write the same erroneous code in the class method, but putting the database access into the scope does the following:
- Helps identify patterns and concerns
  - E.G. while implementing `ListItem.search_by_name` you see that other similar methods in the model are taking care to filter out ListItems that have already been purchased, so you take care to include that in your first iteration
- Helps identify opportunities for reuse
  - E.G. while implementing `ListItem.search_by_name` you see that somebody has already implemented a general `ListItem.search` with all the appropriate error handling and filtering, so you use that instead to avoid having two different search functions. 

## ListItem Exceptions

The ListItem class has its own error hierarchy which it raises instead of the base ActiveRecord exceptions.

A more idiomatic Rails approach would be to simply rely on the ActiveRecord exceptions, and include knowledge of ActiveRecord all the way through the controller and view layers. The `list_item.errors` field would contain all model violations, which I would then print out to the user.

I prefer to rely as much as possible on exceptions defined by the application in question, to avoid scenarios like the following:

Suppose that I added a field to the database called `price` that kept track of how much the family was willing to spend on that item. I might then go
and add a model validation to the LineItem model that specified that the field must be present at all times. After updating the fixtures accordingly, all the tests will pass. But the production database has records where price is not defined, so exceptions will be raised when those records are being loaded by real users in production.

If my controllers had blanket handling of ActiveRecord errors, these exceptions would be passed along to the user, and my monitors would tell me that everything was working just fine. I would actually have to receive a report from a user before I even realized something was wrong.

With my approach, where I only rescue specific exceptions that reflect scenarios I'm expecting, the scenario above would have resulted in 500s immediately, notifying me that something was wrong before a user had to make a report.

In fact, not only do I only catch exceptions for scenarios I'm aware of, I only catch them in specific controller routes where I know those errors could occur. For example, I catch `NameTooLong` errors only when I'm adding an item or editing an item's name, and not when I'm marking an item as purchased. If the error was raised during the mark purchased flow, that would be an unexpected scenario and I'd want 500s to trigger my monitoring ASAP.

## ListItemController exception messaging

The controller catches multiple user errors, including missing parameters (captured via `param.require`), as well as bad parameters resulting in a name that's too long or a not found error.

It's important to catch these errors so that unusual user behaviour, like a bot using the site, doesn't trigger monitors/alerts for the site, but it only makes sense to notify the user when
it's something they can reasonably control. Since the user in this case is interacting with the backend via a browser, it's not within their control whether or not the request is properly built, like when a parameter is missing, so in those cases we just state that something has gone wrong on our end and that they should try refreshing (since hopefully whatever issue they encountered isn't present on the lastest version of the site).

The only case where we actually send a message to the user for them to parse is when they've sent an item name that is too long- since that's within their control to fix.

If in the future we exposed this backend as an API to be accessed programatically, we'd add in additional information for the user to debug their applications. 

## Rails Serverside Rendering

List items are rendered via the Rails Serverside rendering system. It uses ERB templates to construct basic HTML based on the state of the records passed by the controller.

Using a javascript framework like Angular or React would provide a much better experience here, because we could avoid reloading the page after each update, but due to the limited time I had available to solve the problem I opted to focus on the backend, my area of expertise.

There are some advantages to this approach as well- since it's all plain HTML, it's responsive to mobile formats without any effort, I had no issue using it on my IPhone. It also loads quite quickly as there's no JQuery/etc libraries that need to be loaded. 

## Testing layers

The testing for this application is split into three separate layers. Each layer is standard as per [Rails test documentation](https://guides.rubyonrails.org/testing.html).

1. System tests

Using Capybara, a test framework that simulates the website via a browser emulator, I validate that the user flows work as expected in terms of
raw user inputs (clicking buttons, typing characters) and DOM outputs (item present/not present, buttons disabled/enabled).

This test can be found in `test/system/list_items_test.rb`

2. Functional Controller tests

An integration test that isolates the backend as a unit. In this project, there is just one: `test/controllers/list_item_controller_test.rb`

3. Unit tests

Includes only the `LineItem` interface in `test/models/line_item_test.rb`. The controller is considered to be covered by the Functional Controller tests, and as a rule should not be so complex that it merits a separate unit test.

## System tests in Docker

The current implementation of the app does not enable the user to run system tests just with docker compose. Such a thing is certainly possible, with
multiple documented routes for doing so ([1](https://avdi.codes/run-rails-6-system-tests-in-docker-using-a-host-browser/),[2](https://nicolasiensen.github.io/2022-03-11-running-rails-system-tests-with-docker/)), but I wasn't able to pursue those approaches to completion due to timing constraints.

Instead, I've recorded a video of the tests running, to spare the reviewer from having to complete a local installation:

https://github.com/user-attachments/assets/074dc437-da92-4e35-9011-d35496dca2c6

With infinite time, I'd likely spend a bit more time here so that users could be completely reliant on Docker and avoid installing postgres locally, though it might also not be worth the additional complexity and latency. It's something I'd need to discuss further with the team, if this was a real app built by a team.

## Asset Pipeline

You may notice that I've disabled the asset pipeline. Since we have almost no assets to manage, just a single CSS file, I found they were just adding bloat.

In a real application with a js framework, I would use the Rails asset pipeline as designed.