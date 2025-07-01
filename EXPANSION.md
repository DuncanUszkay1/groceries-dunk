# Expansions

This document contains a list of natural expansions to this application.

## User-bound lists

There's currently only a single, global list for all users. For this app to be generally more useful, we'd need to introduce the concept of `Users` and `Lists`, where Users have access to multiple Lists, and `ListItems` are associated to a list.

### Creation and Sharing flow

A separate form would be created for a `User` to create a `List` that they own. The ownership would be reflected by a `ListPermission` record that links the user and the list together along with a specification of permissions given to the user. In this case it'd be read, write, and share permissions.

The owner would then be able to share that list with other users by:
- Specifying the user to be shared with by the email associated with their `User` record
- Specifying which permissions they should be given out of read, write, and share
- Sending them a link that allows them to verify that they would like to join the list
- Adding a record to a `ListPermission` table which gives the user the appropriate accesses

### List Routes and Menu

To enable users to switch between lists, we'd have a menu visible on each page that shows all the lists they have access to, which would link them to the appropriate location.

Each `List` would have its own unique URL in the form of:
`/list/<list id>/line_item/...`

If a user browses to the root, we redirect them to their most recently created List.

### Changes to List interaction

We would update our algorithms in the controller to include the following steps:
- Start off each process by identifying the user using an authentication token they retrieved through some login flow
- Determine the list being interacted with using request parameters
- If the user doesn't have access to the list, we return 404 (not 401, since that would enable the user to scan for all in-use IDs)
- Otherwise, we continue with our operations on `ListItem` scoped to that particular list
  - List IDs would need to be included in the ListItem table, and they would need to be indexed

## Integrations

For the product to be useful, it would have to be deeply integrated with other popular TODO-list style services, like "Microsoft To Do", as well as apps which could source lists, like receipie apps.

## Tenant Sharding

As the app expands, we'll want to find ways to scale horizontally.

The web workers can expand trivially with the addition of a proxy that can perform load balancing, like NGINX.

The more complex concern will be how to shard the database so that we can increase the load horizontally. My proposal to accomplish that would be:
- Shard `Lists` and `ListItems` such that each DB contains a subset of `Lists` and all of the corresponding `ListItems` and `ListPermissions`.
- Have a separate pool of web workers for each of these shards
- Keep a mapping of list IDs to shards in the proxy, so that incoming requests can be directed to the correct pool of workers where that list's data is available
- Store User data on a separate login service used only to give them an authentication token that proves to the list application that they are the user they claim to be
- Keep an eventually-consistent list of `List` IDs the user has access to on the user service, to populate the menu of lists discussed above.
  - Enqueue a job to update that list whenever a share event happens

Diagram:

<img width="1766" alt="Screenshot 2025-07-01 at 1 28 59 PM" src="https://github.com/user-attachments/assets/6cb64100-263f-44ba-8e33-fd39b9381e6d" />
