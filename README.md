
A tool/library to run a Nim command periodically

which provides a compiler that compiles nim-like script to executable

## Usage

### Compile the `daily_run` compiler

You can either install the compiler or only build it
#### 1. build and install
```shell
nimble install
```
And then you shall be able to run `daily_run`

#### 2. only build compiler
Use

```shell
nimble build
```
to compile.

and then `daily_run` or `daily_run.exe` will be in project root directoy

### Write the script

the script, with `.dnim` as file extension, is just a Nim Language code
but will be embeded with prefix of some `import dialy_run` and suffix of `mainloop()`

## Example
See [basic example](./examples/basic.dnim)
