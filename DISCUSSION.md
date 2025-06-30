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
- In a future implementation, we could imagine that these operations may have differenet expectations in terms of latency, timeline for eventual consistency, permissions, and so on. This approach will make it easy to have that fine grained level of control as those requirements deviate

## Rails Serverside Rendering

List items are rendered via the Rails Serverside rendering system. It uses ERB templates to construct basic HTML based on the state of the records passed by the controller.

Using a javascript framework like Angular or React would provide a much better experience here, because we could minimize page loads, but due to the limited time I had available to solve the problem I opted to focus on the backend, my area of expertise.