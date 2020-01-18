# Contains helper functions to configure the environment for Vim.

function Vimrc-Status() {
    Vimrc-Rust-Enabled
    Vimrc-Snippet-Enabled
    Vimrc-Virtual-Text-Enabled
    Vimrc-Background
}

function Vimrc-Rust-Enabled() {
    Param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("true", "false")]
        [String]$Enabled=""
     )

    if ($Enabled -eq "true") {
        $env:VIMRC_RUST_ENABLED=1
    }
    elseif ($Enabled -eq "false") {
        $env:VIMRC_RUST_ENABLED=0
    }

    if (Test-Path env:VIMRC_RUST_ENABLED) {
        if ($env:VIMRC_RUST_ENABLED -eq 1) {
            Write-Host "[vimrc] Rust support is enabled."
        }
        else {
            Write-Host "[vimrc] Rust support is disabled."
        }
    }
    else {
        Write-Host "[vimrc] VIMRC_RUST_ENABLED environment variable is not used."
    }
}

function Vimrc-Snippet-Enabled() {
    Param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("true", "false")]
        [String]$Enabled=""
     )

    if ($Enabled -eq "true") {
        $env:VIMRC_SNIPPET_ENABLED=1
    }
    elseif ($Enabled -eq "false") {
        $env:VIMRC_SNIPPET_ENABLED=0
    }

    if (Test-Path env:VIMRC_SNIPPET_ENABLED) {
        if ($env:VIMRC_SNIPPET_ENABLED -eq 1) {
            Write-Host "[vimrc] Snippet support is enabled."
        }
        else {
            Write-Host "[vimrc] Snippet support is disabled."
        }
    }
    else {
        Write-Host "[vimrc] VIMRC_SNIPPET_ENABLED environment variable is not used."
    }
}

function Vimrc-Virtual-Text-Enabled() {
    Param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("true", "false")]
        [String]$Enabled=""
     )

    if ($Enabled -eq "true") {
        $env:VIMRC_USE_VIRTUAL_TEXT=1
    }
    elseif ($Enabled -eq "false") {
        $env:VIMRC_USE_VIRTUAL_TEXT=0
    }

    if (Test-Path env:VIMRC_USE_VIRTUAL_TEXT) {
        if ($env:VIMRC_USE_VIRTUAL_TEXT -eq 1) {
            Write-Host "[vimrc] Virtual text support is enabled."
        }
        else {
            Write-Host "[vimrc] Virtual text support is disabled."
        }
    }
    else {
        Write-Host "[vimrc] VIMRC_USE_VIRTUAL_TEXT environment variable is not used."
    }
}

function Vimrc-Background() {
    Param(
            [Parameter(Mandatory=$false)]
            [ValidateSet("light", "dark")]
            [String]$Change=""
         )

        if ($Change -ne "") {
            $env:VIMRC_BACKGROUND=$Change
        }

    if (Test-Path env:VIMRC_BACKGROUND) {
        Write-Host "[vimrc] Background color is set to ${env:VIMRC_BACKGROUND}."
    }
    else {
        Write-Host "[vimrc] VIMRC_BACKGROUND environment variable is not used."
    }
}
