// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_cors

@Annotation[target: [MemberFunction, Type]]
public class EnableCors <: IEnableCors {
    private let _policyName: ?String

    public const init(policyName: ?String) {
        _policyName = policyName
    }

    public prop policyName: ?String {
        get() {
            _policyName
        }
    }
}
