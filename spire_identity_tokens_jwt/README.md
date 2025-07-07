# spire_identity_tokens_jwt

## 使用对称密钥

* 创建令牌

``` cangjie
let securityKey = SymmetricSecurityKey("vIBUnd5LbR3WWddFn6D6c0YUXm8v7BA2vog4CLFInYmDM6RZJHg7E0Jqagomh".toArray())
let header = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256))
let payload = JwtPayload(
    issuer: "spire",
    audience: "cangjie",
    notBefore: DateTime.now(),
    expires: DateTime.now().addHours(1),
    claims: [("sub", "1024")]
)
var jwtToken = JwtSecurityToken(header, payload)
let tokenHandler = JwtSecurityTokenHandler()
tokenHandler.writeToken(jwtToken) |> println

```

* 验证令牌

``` cangjie
let token = '...'
let securityKey = SymmetricSecurityKey("vIBUnd5LbR3WWddFn6D6c0YUXm8v7BA2vog4CLFInYmDM6RZJHg7E0Jqagomh".toArray())
var parameters = TokenValidationParameters()
parameters.issuerSigningKey = securityKey
parameters.validIssuer = "spire"
parameters.validAudience = "cangjie"
parameters.requireExpirationTime = true

let tokenHandler = JwtSecurityTokenHandler()
let result = tokenHandler.validateToken(token, parameters)
if (!result.isValid && let Some(ex) <- result.exception) {
    ex.printStackTrace()
}else {
    "验证成功" |> println
}
```


## 使用非对称密钥

### 使用rsa-256签名的令牌

* 创建令牌

``` cangjie
let pem = RSAPrivateKey.decodeFromPem(String.fromUtf8(readToEnd(File("rsa256_private_key.pem", OpenMode.Read))))
let securityKey = RsaSecurityKey(privateKey: pem)
let header = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.RsaSha256))
let payload = JwtPayload(
    issuer: "spire",
    audience: "cangjie",
    notBefore: DateTime.now(),
    expires: DateTime.now(),
    claims: [("sub", "1024")]
)
var jwtToken = JwtSecurityToken(header, payload)
let tokenHandler = JwtSecurityTokenHandler()
tokenHandler.writeToken(jwtToken) |> println
```

* 验证令牌

``` cangjie
let token = '...'
let pem = RSAPublicKey.decodeFromPem(String.fromUtf8(readToEnd(File("rsa256_public_key.pem", OpenMode.Read))))
let securityKey = RsaSecurityKey(publicKey: pem)

//验证参数
var parameters = TokenValidationParameters()
parameters.issuerSigningKey = securityKey
parameters.validIssuer = "spire" //允许的发行方
parameters.validAudience = "cangjie" //允许的受众

//验证
let tokenHandler = JwtSecurityTokenHandler()
let result = tokenHandler.validateToken(token, parameters)

if (!result.isValid && let Some(ex) <- result.exception) {
    ex.printStackTrace()
} else {
    "验证成功" |> println
}
```