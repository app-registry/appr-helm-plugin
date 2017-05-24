## 0.4.0 Released on 2017-05-24
    - Integration with Helm's dependency file `requirements.yaml`
      command: `helm registry dep`
    - Allow push to any repository name,
      it can be different from the application manifest
      command: `helm registry push quay.io/ns/repo-name`
    - Display server-error messages
    - Windows support
