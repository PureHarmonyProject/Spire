// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_authorization

import aspire_web_http.*

@Annotation[target: [Type, MemberFunction]]
public class Authorize <: IAuthorizeData {
    private let _policy: ?String
    private let _authenticationSchemes: ?String

    public const init() {
        this(policy: None, authenticationSchemes: None)
    }

    public const init(policy: String) {
        this(policy: policy, authenticationSchemes: None)
    }

    public const init(policy!: ?String = None, authenticationSchemes!: ?String) {
        _policy = policy
        _authenticationSchemes = authenticationSchemes
    }

    public prop policy: ?String {
        get() {
            _policy
        }
    }

    public prop authenticationSchemes: ?String {
        get() {
            _authenticationSchemes
        }
    }
}
