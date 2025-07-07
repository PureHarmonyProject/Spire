// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package spire_identity_tokens

import stdx.crypto.keys.*

public class JsonWebKeyConverter {
   
    public static func convert(key: SymmetricSecurityKey, algorithm!: ?String = None) {
        let k = Base64UrlEncoder.encode(key.key)
        return JsonWebKey(k: k, kty:"oct", use: "sig", alg: algorithm)
    }

    public static func convert(key: ECDsaSecurityKey, algorithm!: ?String = None) {
        let jwk = JsonWebKey()
        jwk.kty = "EC"
        jwk.use = "sig"
        jwk.alg = algorithm
        if (let Some(alg) <- algorithm) {
            jwk.crv = CryptoHelper.getCrvParameterValue(alg)
        }
        if (let Some(parameters) <- key.exportParameters()) {
            jwk.x = Base64UrlEncoder.encode(parameters.q.x)
            jwk.y = Base64UrlEncoder.encode(parameters.q.x)
        }
        return jwk
    }

    public static func convert(key: RsaSecurityKey, algorithm!: ?String = None) {
        let jwk = JsonWebKey()
        jwk.kty = "RSA"
        jwk.use = "sig"
        jwk.alg = algorithm
        jwk.kid = key.keyId
        if (let Some(alg) <- algorithm) {
            jwk.crv = CryptoHelper.getCrvParameterValue(alg)
        }
        if (let Some(parameters) <- key.exportParameters()) {
            if (let Some(data) <- parameters.exponent) {
                jwk.e = Base64UrlEncoder.encode(data)    
            }
            if (let Some(data) <- parameters.modulus) {
                jwk.n = Base64UrlEncoder.encode(data)    
            }
        }
        return jwk
    }

    public static func convert(signingCredentials: SigningCredentials) {
        if (let Some(key) <- (signingCredentials.key as SymmetricSecurityKey)) {
            return convert(key, algorithm: signingCredentials.algorithm)
        }
        if (let Some(key) <- (signingCredentials.key as ECDsaSecurityKey)) {
            return convert(key, algorithm: signingCredentials.algorithm)
        }
        if (let Some(key) <- (signingCredentials.key as RsaSecurityKey)) {
            return convert(key, algorithm: signingCredentials.algorithm)
        }
        throw UnsupportedException()
    }
}
