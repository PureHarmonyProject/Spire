# aspire_identity_claims

## 创建身份

``` cangjie

let claimsIdentity = ClaimsIdentity([Claim("sub", "1024"), Claim("name", "aspire")])

```

## 创建身份集

``` cangjie
let claimsIdentity1 = ClaimsIdentity("basic", [Claim("sub", "1024"), Claim("name", "aspire")])
let claimsIdentity2 = ClaimsIdentity("jwtbearer", [Claim("sub", "1024"), Claim("name", "aspire")])
let subject = ClaimsPrincipal(claimsIdentity1, claimsIdentity2)
```