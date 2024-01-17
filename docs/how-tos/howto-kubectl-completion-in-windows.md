# How-To: Set up kubectl autocomplete in Windows

Perhaps you have installed a minikube cluster on top of Docker Desktop. Perhaps at your workplace, you have Windows workstations for accessing the corporate clusters. You wish you could use `k` alias and autocomplete just like in the KodeKloud Labs...

Well, actually you can when using PowerShell command prompt! This can be configured and can be made to persist between sessions and reboots. It will also work in VSCode terminals (which are PowerShell)

## One-off setup

This will make it work for the current session

1. Open a PowerShell terminal
1. Run the following commands

    ```powershell
    kubectl completion powershell | Out-String | Invoke-Expression
    Set-Alias -Name k -Value 'kubectl'
    Register-ArgumentCompleter -CommandName 'k' -ScriptBlock $__kubectlCompleterBlock
    ```

That's it, all done! Autocompletion works the PowerShell way, not the Linux way. That is, it cycles through the available options that match the prefix you've typed. If you're used to using auto-complete with other PowerShell commands, then it should feel natural enough.

What just happened?

* The first command sets up autocomplete for `kubectl.exe`. So now it works just for that. It also as a side-effect leaves the scriptblock variable `$__kubectlCompleterBlock` in the session's variables, which we can make use of.
* The next command creates the `k` alias.
* The final command binds the same auto-completion to the `k` alias by way of the scriptblock variable mentioned above.

## Persistent Setup

Now to make it so that the above is automatically configured when any PowerShell terminal is opened, be it Windows PowerShell, PowerShell Core or VSCode. We do this using PowerShell profile scripts, and these scripts once created can be added to to add additional functionality to your shells.

What we will do is to create one shared profile script, and link all the different terminal types to that one script.

1.  Create the shared profile script. This will contain everything we want to run when a PowerShell command prompt is opened

    1. In a text editor, create a new file `C:\Users\<your-user-name>\Documents\WindowsPowerShell\_profileShared.ps1`
    1. Put into this file the three commands from the section above for setting up autocomplete.
    1. Save it.

1.  Link Windows PowerShell (regular shell) to it.

    1. In the same folder, create the file `Microsoft.PowerShell_profile.ps1`
    1. In this file, put the following. Note the leading full stop - it's not a typo!

        ```powershell
        . (Join-Path $PSScriptRoot _profileShared.ps1)
        ```

1.  Link VSCode (Windows PowerShell terminal)

    1. Again in the same folder, create the file `Microsoft.VSCode_profile.ps1`
    1. In this file, put the following

        ```powershell
        . (Join-Path $PSScriptRoot _profileShared.ps1)
        ```

1.  Link PowerShell Core (regular shell) to it. If you don't have PowerShell Core, the following directory will not exist, so omit this and the next step

    1. Create file `C:\Users\<your-user-name>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
    1. In this file, put the following

        ```powershell
        . (Join-Path $PSScriptRoot "../WindowsPowerShell/_profileShared.ps1")
        ```

1.  Link VSCode (PowerShell Core terminal)

    1. Create file `C:\Users\<your-user-name>\Documents\PowerShell\Microsoft.VSCode_profile.ps1`
    1. In this file, put the following

        ```powershell
        . (Join-Path $PSScriptRoot "../WindowsPowerShell/_profileShared.ps1")
        ```

Now open any new PowerShell window and the changes will be there.

## Bonus addition

It would also be nice to run something like this in Windows

```
k get secret my-secret -o jsonpath='{.data.seretkey}' | base64 -d
```

...but Windows doesn't by default have a program called `base64`. Yes you can install Windows ports of Unix-like utilities, but these (like `unxutils`) are not well maintained these days. We can simulate this by adding a "poor man's base64" to our PowerShell shared profile

1. In a text editor, edit `C:\Users\<your-user-name>\Documents\WindowsPowerShell\_profileShared.ps1`
1. Add the following to the end

    ```powershell
    function base64
    {
        param
        (
            [Parameter(ValueFromPipeline = $true)]
            [string]$Data,

            [SwitchParameter]$d
        )

        if ($d) {
            [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Data))
        }
        else {
            [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Data))
        }
    }
    ```
1. Save that, open a new PowerShell window, and the above `k get secret` will work and decode the secret!