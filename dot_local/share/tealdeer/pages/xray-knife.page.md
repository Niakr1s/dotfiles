# xray-knife

> xray-knife is a tool to manage and run VPN

- add a subscription:
`xray-knife subs add --url "https://example.com/sub" --remark "My VPN"`

- update subscriptions:
`xray-knife subs fetch --all`

- show subscriptions:
`xray-knife subs show`

- remove a subscription:
`xray-knife subs rm <id>`

- disable a subscription:
`xray-knife subs update --id <id> --enabled false`

- don't forget to reload the service:
`systemctl --user restart xray-knife`
