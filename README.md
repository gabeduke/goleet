# GoLeet

Collection of apps and packages to ease scripting in Go.

## Usage

_Repository format_:
 
* folders in the apps directory is a self documenting executable program that should handle it's own dependencies
* packages can be imported and shared across libraries. They should be testable and expose an interface where possible

```sh
.
├── Makefile
├── pkg
│   ├── codes
│   └── ...
├── README.md
└── apps
    └── hello
        ├── README.md
        └── hello.go
```

### Usage

**Simple**:

To run programs in the `apps/` folder simply use `go run apps/[pkg]/[app].go`

**Advanced**:

Scripts may also be run as an executable on systems that support [/proc/sys/fs/binfmt_misc](https://blog.cloudflare.com/using-go-as-a-scripting-language-in-linux/).

`make init` will perform the following steps:

* download and install [gorun](https://github.com/erning/gorun) to `/usr/local/bin`
* register `gorun` to `/proc/sys/fs/binfmt_misc/register` in order to recognize `*.go` files as executable