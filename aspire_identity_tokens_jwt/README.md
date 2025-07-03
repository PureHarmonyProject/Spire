# aspire_identity_tokens_jwt

## 创建rsa-256签名的token

``` cangjie
let pem = RSAPrivateKey.decodeFromPem(String.fromUtf8(readToEnd(File("rsa256_private_key.pem", OpenMode.Read))))
let securityKey = RsaSecurityKey(privateKey: pem)
let header = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.RsaSha256))
let payload = JwtPayload(
    issuer: "aspire",
    audience: "cangjie",
    notBefore: DateTime.now(),
    expires: DateTime.now(),
    claims: [("sub", "1024")]
)
var jwtToken = JwtSecurityToken(header, payload)
let tokenHandler = JwtSecurityTokenHandler()
tokenHandler.writeToken(jwtToken) |> println
```

## 验证rsa-256签名的token

``` cangjie
let token = '...'

//验证参数
var parameters = TokenValidationParameters()
parameters.issuerSigningKey = securityKey
parameters.validIssuer = "cangjie" //允许的发行方
parameters.validAudience = "cangjie" //允许的受众

//验证
let tokenHandler = JwtSecurityTokenHandler()
let result = tokenHandler.validateToken(tokenHandler.writeToken(jwtToken), parameters)

//打印
if (result.isValid) {
    for (pattern in result.subject.claims) {
        println("${pattern.name}=${pattern.value}")
    }
}
```