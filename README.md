# cookbook-app

* Installs/configures a generic, somewhat barebones development environment for a node.js or Go application. Can be extended as a solution for multiple environments and/or for different platforms and languages.
* Uses Vagrant, Chef and Berkshelf for provisioning and setting up nodejs and Go on the VM
* Sets up Docker and runs a couple of containers - MongoDB and gnatsd, but can be easily modified to install and run others

## Supported Platforms

* Ubuntu 14.04

## Usage

### application::default

Include `application` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[application::default]"
  ]
}
```

To test, simply run `vagrant up` then `vagrant ssh` to log into the development environment.


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Tom Rogers (tom@tomoro.io)
