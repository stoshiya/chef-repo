stunnel Cookbook
================

Usage
-----
#### stunnel::default

Just include `stunnel` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[stunnel]"
  ]
}
```

You can customize configuration of `stunnel` using `Attributes`.

e.g.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[stunnel]"
  ],
  "stunnel": {
    "targets": [
		{ "name" : "example1.com", "port" : 1443 },
		{ "name" : "example2.com", "port" : 1444 }
    ]
  }
}
```

Attributes
----------

#### stunnel::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['stunnel']['targets']</tt></td>
    <td>List</td>
    <td>tunnel target</td>
    <td><tt>{ "name" : "example.com", "port" : 1443 }</tt></td>
  </tr>
</table>