// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package spire_identity_tokens

import stdx.crypto.keys.*

public class JsonWebKeyConverter {
    public static func convertFromSymmetricSecurityKey(key: SymmetricSecurityKey, algorithm!: ?String = None) {
        let k = Base64UrlEncoder.encode(key.key)
        return JsonWebKey(k: k, kty: JsonWebAlgorithmsKeyTypes.Octet, use: "sig", alg: algorithm)
    }

    public static func convertFromECDsaSecurityKey(key: ECDsaSecurityKey, algorithm!: ?String = None) {
        let jsonWebKey = JsonWebKey()
        jsonWebKey.kty = JsonWebAlgorithmsKeyTypes.EllipticCurve
        jsonWebKey.use = "sig"
        jsonWebKey.alg = algorithm
        if (let Some(alg) <- algorithm) {
            jsonWebKey.crv = CryptoHelper.getCrvParameterValue(alg)
        }
        if (let Some(parameters) <- key.exportParameters()) {
            jsonWebKey.x = Base64UrlEncoder.encode(parameters.q.x)
            jsonWebKey.y = Base64UrlEncoder.encode(parameters.q.x)
        }
        return jsonWebKey
    }

    public static func ConvertFromRSASecurityKey(key: RsaSecurityKey, algorithm!: ?String = None) {
        let jsonWebKey = JsonWebKey()
        jsonWebKey.kty = JsonWebAlgorithmsKeyTypes.RSA
        jsonWebKey.use = "sig"
        jsonWebKey.alg = algorithm
        jsonWebKey.kid = key.keyId
        if (let Some(alg) <- algorithm) {
            jsonWebKey.crv = CryptoHelper.getCrvParameterValue(alg)
        }
        if (let Some(parameters) <- key.exportParameters()) {
            if (let Some(data) <- parameters.exponent) {
                jsonWebKey.e = Base64UrlEncoder.encode(data)
            }
            if (let Some(data) <- parameters.modulus) {
                jsonWebKey.n = Base64UrlEncoder.encode(data)
            }
        }
        return jsonWebKey
    }

    public static func convertFromSigningCredentials(signingCredentials: SigningCredentials) {
        if (let Some(key) <- (signingCredentials.key as SymmetricSecurityKey)) {
            return convertFromSymmetricSecurityKey(key, algorithm: signingCredentials.algorithm)
        }
        if (let Some(key) <- (signingCredentials.key as ECDsaSecurityKey)) {
            return convertFromECDsaSecurityKey(key, algorithm: signingCredentials.algorithm)
        }
        if (let Some(key) <- (signingCredentials.key as RsaSecurityKey)) {
            return ConvertFromRSASecurityKey(key, algorithm: signingCredentials.algorithm)
        }
        throw UnsupportedException()
    }

    public static func convertToSymmetricSecurityKey(jsonWebKey: JsonWebKey): ?SymmetricSecurityKey {
        if (jsonWebKey.kty.flatMap {f => f == JsonWebAlgorithmsKeyTypes.Octet} != true) {
            return None
        }
        if (let Some(k) <- jsonWebKey.k && let Some(key) <- Base64UrlEncoder.decode(k)) {
            return SymmetricSecurityKey(key)
        }
        return None
    }
}
