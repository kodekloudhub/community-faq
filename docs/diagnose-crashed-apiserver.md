# How to Diagnose a Crashed API Server

The API server pod won't come back up - HELP :scream: :scream: :scream:

Perhaps you've made a manifest edit, or perhaps some question has put you into a context where the API server is already broken. You're using `docker ps` or `crictl ps` and see the API server flash up briefly then go away. The container doesn't last long enough for you to grab an ID to pull logs from. Or maybe it never appears in the `ps` output.

Note that these techniques can be used for the other static pods like `etcd` by looking for `etcd` instead of `apiserver` in the commands below.

Steps to take

1.  Restart `kubelet` so you don't have to wait too long in the following steps</br></br>
    ```
    systemctl restart kubelet
    ```

1.  Determine if the kubelet can even start the API server</br></br>
    If there is a syntax error in the YAML manifest, then kubelet will not be able to parse it and will eventually complain. Do the following and watch the output for up to 60 seconds

    ```
    journalctl -fu kubelet | grep apiserver
    ```

    If you see any obvious messages, then this is your issue. Note that YAML parsers only report the first error they find. If you have more than one error - i.e. the apiserver doesn't come up after fixing whatever you've found, then repeat this diagnostic process from the top.
1.  Kubelet does launch API server, but it crashes immediately.</br></br>
    This means there is likely an issue with one or more arguments to the `kube-apiserver` command. There is a location where the last output of the pod is stored, which can help you to get information about why the pod is not starting.

    ```
    cd /var/log/pods
    ls -ld *apiserver*
    ```

    This should return something like

    ```
    drwxr-xr-x 3 root root 4096 Oct 26 04:29 kube-system_kube-apiserver-controlplane_02d13ddeddf8e935ec2407132767aeaa
    ```

    **NOTE**: This directory can change name frequently. If you have to repeat the diagnostic process, don't assume it is the same as last time you did this in the same session. Repeat this step from the top.

    Next, `cd` into the given directory

    ```
    cd kube-system_kube-apiserver-controlplane_02d13ddeddf8e935ec2407132767aeaa
    ls -l
    ```

    You should see

    ```
    drwxr-xr-x 2 root root 4096 Oct 26 04:29 kube-apiserver
    ```

    ```
    cd kube-api-server
    ls -l
    ```

    There will be one or more `.log` files. Examine the content of the most recent log, e.g.

    ```
    cat 1.log
    ```

    The issue should be revealed here.

Practice this on [Killercoda](https://killercoda.com/killer-shell-cka/scenario/apiserver-crash). You can sign up for free via social media.

[Return to main FAQ](../README.md)