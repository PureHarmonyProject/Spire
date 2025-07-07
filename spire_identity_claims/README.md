# spire_identity_claims

## 创建身份

``` cangjie

let claimsIdentity = ClaimsIdentity([Claim("sub", "1024"), Claim("name", "spire")])

```

## 创建身份集

``` cangjie
let claimsIdentity1 = ClaimsIdentity("basic", [Claim("sub", "1024"), Claim("name", "spire")])
let claimsIdentity2 = ClaimsIdentity("jwtbearer", [Claim("sub", "1024"), Claim("name", "spire")])
let subject = ClaimsPrincipal(claimsIdentity1, claimsIdentity2)
```