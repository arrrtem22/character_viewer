
## Getting Started 🚀

If you are running the project for the first time and you do not have anything installed to work with flutter, you need to run this command:

```sh
make bootstrap
```

P.S. this script only for mac

# Build

Flutter version: 3.16.4

P.S. make sure you have **xcode** and **android studio** installed

# Development

Set Additional run args from Edit configuration menu as `--dart-define=ENV=simpsons` (simpsons, wire)

This command need for update all generated files:

```sh
make gen-force
```

For cleaning all dependencies, you can call the command:

```sh
make clean
```

Use the following commands to run the project:

```sh
fvm flutter pub upgrade
make gen-force
fvm flutter run --release
```

If you are working through VSCode, you can run the project through the schema, but before that, do not forget to run the commands:

```sh
fvm flutter pub upgrade
make gen-force
```

# Project information

## Config

To add new settings, you need to add parameters to the directory **/common/constant**


## DI

To work with DI, injection is used. Job descriptions can be found **/common/injection**

If you need to create a singleton object, then you need to add the **@singleton** prefix above the class for all other cases of **@injection**

## Navigation

The go_router package is used for navigation. The description of all routes is described in the general file in the directory **/common/router**


## Feature

To create a new feature, use the command

```sh
make add-feature name=#the name of your feature
```

## DTO

To create a new dto, use the command

```sh
make add-dto name=#the name of your dto
```

## API

To create a new api, use the command

```sh
make add-api name=#the name of your api
```