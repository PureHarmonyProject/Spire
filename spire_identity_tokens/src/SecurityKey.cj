// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_tokens

import stdx.crypto.x509.*
import std.crypto.digest.*
import stdx.serialization.serialization.*

public abstract class SecurityKey {
   public prop keyId: ?String
   public prop keySize: Int64
}
