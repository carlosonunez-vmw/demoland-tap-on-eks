# Example App Backend

This is a simple backend for the `example-app` workload created by
the "Angular Frontend" accelerator.

All it does is respond to the HTTP endpoints that the Angular Frontend
expects to be available.

## Examples

### Getting Customer Profiles

```text
$: curl localhost:8080/api/customer-profiles
[{"id":0,"firstName":"Bob","lastName":"Graves","email":"bobgraves@foo.com"},{"id":1,"firstName":"Bobby","lastName":"Graves","email":"bobgraves@foo.com"},{"id":2,"firstName":"Bobbert","lastName":"Graves","email":"bobgraves@foo.com"},{"id":3,"firstName":"Robert","lastName":"Graves","email":"bobgraves@foo.com"},{"id":4,"firstName":"Robby","lastName":"Graves","email":"bobgraves@foo.com"}]
```

### Adding Customer Profiles

```text
$: curl -X POST -d '{"firstName":"Bob"}' localhost:8080/api/customer-profiles
$: curl localhost:8080/api/customer-profiles
[{"id":0,"firstName":"Bob","lastName":"Graves","email":"bobgraves@foo.com"},{"id":1,"firstName":"Bobby","lastName":"Graves","email":"bobgraves@foo.com"},{"id":2,"firstName":"Bobbert","lastName":"Graves","email":"bobgraves@foo.com"},{"id":3,"firstName":"Robert","lastName":"Graves","email":"bobgraves@foo.com"},{"id":4,"firstName":"Robby","lastName":"Graves","email":"bobgraves@foo.com"},{"id":0,"firstName":"Bob","lastName":"","email":""}]
```

## Testing

Run `docker-compose up -d`, then run the commands shown above to verify that
everything is working.

> ## ✅ Improvement Suggestion: Using `pack`
>
> I wanted to use `pack` so that this app is tested using the same
> container image as the one that will be created for it within TAP.
>
> However, no ARM-based builders exist, and I was too lazy to make one.
>
> Did you fix this problem? Submit a PR!

## Deploying

```sh
tanzu apps workload app -n <YOUR-DEV-NAMESPACE> -f ./conf/workload.yaml
```
