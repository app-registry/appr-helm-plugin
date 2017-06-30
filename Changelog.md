## 0.5.1 Released on 2017-05-24

    - Use the new `appr` binary
    - new command to run a registry server
      ```helm registry run-server```

## 0.4.1 Released on 2017-05-24

    - Download/upgrade the cnr binary from the plugin

## 0.4.0 Released on 2017-05-24

    - Integration with Helm's dependency file `requirements.yaml`
      command: `helm registry dep`
    - Allow push to any repository name,
      it can be different from the application manifest
      command: `helm registry push quay.io/ns/repo-name`
    - Display server-error messages
    - Windows support
