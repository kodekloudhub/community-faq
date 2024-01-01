# YAML FAQ

We see a few questions about "kubectl" YAML manifests and what you can and can't do syntactically, therefore we'll try to clear some of this up.

`kubectl` (and anything else in the ecosystem that needs to read YAML like `kubelet` etc) is built using the standard GoLang YAML package, which apart from anything explicitly mentioned in the package's [Compatibility](https://github.com/go-yaml/yaml#compatibility) paragraph is generally YAML 1.2 compliant (see [gotchas](#gotchas) below), and this is the dialect that `kubectl` understands. There is no "special" `kubectl` dialect.

* [In a nutshell](#in-a-nutshell)
* [Ordering of keys](#ordering-of-keys)
* [To quote or not to quote](#to-quote-or-not-to-quote)
* [Indentation](#indentation)
* [Dealing with Errors (kubectl)](#dealing-with-errors-kubectl)
* [Gotchas](#gotchas)
* [YAML Practice lab](#yaml-practice-lab)
* [Advanced features](#advanced-features)
     * [Documents](#documents)
     * [Aliases and anchors](#aliases-and-anchors)

## In a nutshell

YAML is a superset of JSON and has all the same concepts like objects (a.k.a. dictionary, map) and lists, and combinations of all these

```yaml
myString: I am a string value
myNumber: 123
myBoolean: true
myList:
- value1
- value2
- valuen
myObject:           # Every key-value indented beneath here is part of `myObject` dictionary
  property1: value1
  property2: value2
  propertyn: valuen
```

Every item is a key-value pair, where the key name ends with a `:` and the value follows.

A value may be of any valid type; a scalar (string, number, bool etc.), or a list or another object, so `value1`, `value2`, `valuen` above can be any of these types, however here they are string literals.

This is exactly the same as this JSON

```json
{
    "myString": "I am a string value",
    "myNumber": 123,
    "myBoolean": true,
    "myList": [
        "value1",
        "value2",
        "valuen"
    ],
    "myObject": {
        "property1": "value1",
        "property2": "value2",
        "propertyn": "valuen"
    }
}
```

Any valid JSON is also valid YAML, meaning you can mix and match

```yaml
# Using JSON array for command parameters (known as YAML flow style)
command: ["sleep", "4800"]
```

is equivalent to

```yaml
# Using YAML array for command parameters (known as YAML block style)
command:
- sleep
- "4800"
```

In places where you need to declare an empty YAML object key, then you must use flow style to represent the value as an empty (JSON) object, such as

```yaml
volumes:
- name: my-volume
  emptyDir: {}
```

This is because to put nothing after `emptyDir:` would be a syntax error as the value would be missing. What we are doing is asking for an `emptyDir` volume with no custom properties. There are properties that could be used with this but they are beyond the scope of the exams.

## Ordering of keys

Both YAML and JSON have no restriction on the ordering of keys in an object declaration

All the following have *exactly* the same outcome. Key arrangement is a matter of personal preference, and many programs that save data to YAML files, including `kubectl` will emit the keys in alphabetical order. It so happens when saving kube objects with `-o yaml` that `apiVersion`, `kind`, `metadata`, `spec` are already in alphabetical order, but you'll notice that the keys for each container are sorted.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test
spec:
  containers:
  - name: test
    image: busybox
```

```yaml
metadata:
  name: test
spec:
  containers:
  - name: test
    image: busybox
apiVersion: v1
kind: Pod
```

```yaml
spec:
  containers:
  - image: busybox
    name: test
apiVersion: v1
metadata:
  name: test
kind: Pod
```



## To quote or not to quote

YAML always parses literal values as strings, _unless_ the value is wholly numeric (including canonical, integer, fixed point, exponential, octal or hex), a timestamp or a boolean (`true`, `false`). If you want to force a non-string to be parsed as a string, you must quote it. This rule applies to environment variable values and to command arguments which must both be passed to the underlying container as a string, hence

```yaml
command:
- sleep
- "4800"
```

If you are creating configmaps or secrets for use with environment variables, the same quoting rules apply.

We've seen posts that say "You must quote mount paths" or "You must quote pod capabilities". This is not the case. The rules are as stated above. At the end of the day you want to use as few keystrokes as possible when doing the exam! You only need to quote in flow-style e.g.

```yaml
    securityContext:
      capabilities:
        add: ["NET_ADMIN", "SYS_TIME"]
```

is _exactly_ the same as

```yaml
    securityContext:
      capabilities:
        add:
        - NET_ADMIN
        - SYS_TIME
```
## Indentation

Beware of the pesky indentation rules. Whitespace is part of the syntax like Python, however `TAB` characters are not. Each indentation level should be two spaces. If you mess this up you can get all kinds of different errors from `kubectl` depending on where it was in the file when it encountered the error.

Lists may be introduced at the same level as the parent key, or indented. Both the following lists are valid

```yaml
list1:
- value1

list2:
  - value2
```
* Make sure vim is not inserting `TAB` instead of spaces, or you will get cryptic errors from `kubectl`!
* Remember to use `INSERT (paste)` mode when pasting YAML from documentation, and toggle paste mode OFF before hitting tab on the keyboard.

The following vim settings in .vimrc work for me, but many people have posted other settings in blogs like Medium.

```
set nu
set ts=2
set sw=2
set et
set ai
set pastetoggle=<F3>
```

What these do, in order:

1. Enable line numbers
2. Set shift width 2 chars
3. Expand tabs to spaces
4. Set tab stop to 2 chars
5. Enable auto indent
6. NOTE - this was not working properly in the exam as of 2022-07-06. See [Issues with Exam Portal](https://github.com/fireflycons/tips-for-CKA-CKAD-CKS#issues-with-the-exam-portal).<br>Set F3 key to toggle paste mode. This is super important when pasting from the Kubernetes docs. Enter insert mode `i` then press `F3` so the bottom line reads<br>`INSERT (paste)`<br>Once you've pasted, ensure to toggle paste mode OFF again, or `TAB` key will start inserting tab characters and `kubectl` will complain!

Paste mode may also be toggled from vi [normal mode](https://www.freecodecamp.org/news/vim-editor-modes-explained/) with the following commands:

* `:set paste`
* `:set nopaste`

## Dealing with errors (kubectl)

When a manifest is read, it is a two-pass operation

1. The YAML is read in and converted to JSON. In this phase, errors specific to the grammar of YAML itself will be detected. If it gets past this phase, then the YAML is syntactically correct _as far as YAML grammar goes_. These errors have line number context and will be shown as

    ```
    (yaml: line #: error message)
    ```

    You should enable line numbers in `vi` to help you get to these errors quickly. If line numbers are not showing, enter `:set nu` into `vi` before entering insert mode.

    If the manifest file being read has [multiple documents](#documents), then the error line number is relative to the beginning of the document currently being read, not the beginning of the file. You can use [relative line numbers](./vi-101.md#relative-numbers) in vi to get to the correct line of a document further down the manifest file.


2. Once the YAML has successfully been converted to JSON, then the JSON is marshalled to Go structures internally (i.e. the programmatic representation of pods, deployments, etc.). These errors are generally of the form

    ```
    (json: cannot unmarshal _something_ into Go _something_else_ of type _sometype_)
    ```

    This means that you have probably missed a key, or put a list or a string literal where there should have been a map. Basically what you've put for a pod is syntactically correct YAML, but that YAML does not correctly represent a pod.<br/><br/>You can get a clue as to where the error is from the `something_else`. Say that is `PodSpec.spec.containers` then it's in the `containers:` section of the manifest. Say it's `Volume.spec.volumes.hostPath` then it's a `hostPath:` within one of your `volumes:`.

    Essentially you have supplied the wrong data type at the manifest path indicated by _something_else_. You can use this information in a `kubectl explain` to find out what should be there, so for the above `PodSpec.spec.containers`:

    1. From the _something_else_ omit the first `Spec` (if present and has capital S), then lowercase what remains, e.g. `PodSpec` = `pod`, `PersistentVolumeSpec` = `persistentvolume`.
    2. Make an explain command

        ```
        kubectl explain pod.spec.containers
        ```


A manifest parse stops at the first error encountered, as it loses context and cannot continue. This means if you have made multiple errors you have to fix one to be able to find the next, therefore getting it right is an iterative process!



Some common errors you'll get from Kubernetes components when your YAML is malformed are shown below. I'm showing the _relevant_ portion of the error messages:

* TABs

    ```
    (yaml: line 67: found character that cannot start any token)
    ```

    Usually indicative of `TAB` characters found where there should be spaces at the given line.

* Incorrect indention causing map when list is expected

    ```
    (yaml: line 56: mapping values are not allowed in this context)
    ```

    Here the error is caused by

    ```yaml
    spec:
      containers:
      name: nginx     # <- line 56
    ```

    `name` is not an allowed key for `spec`, which is how we've put it. `name` is actually part of a container definition and `containers` is a _list_ of container defintions. Should have been

    ```yaml
    spec:
      containers:
      - name: nginx
    ```
* Unknown field

    ```
    Error from server (BadRequest): error when creating "some-pod":
    Pod in version "v1" cannot be handled as a Pod: strict decoding error: unknown field "spec.containers[0].dnsPolicy"
    ```

    Again, usually an indentation problem (in this case), or it really is a field that doesn't exist e.g. you put `foobar` or some other nonsense, or you simply typoed the key name.

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: test
    spec:
      containers:
      - image: busybox
        name: test
        command:
        - sleep
        - "1800"
        dnsPolicy: ClusterFirst  #<- This is indented too far
    ```

    In the example above `dnsPolicy` has been indented to be part of the first container (i.e. `containers[0]`), and as such is an unknown field for a container specification. It should be part of `spec` for the pod itslf.

* Could not find expected key

    ```
    (yaml: line 106: did not find expected key)
    ```

    Most likely you inserted a new list item somewhere near the given line, but did not specify it as a list item, e.g.

    ```yaml
      volumes:
        hostPath:                    # <- you inserted this volume
          path: /etc/ssl/certs
          type: DirectoryOrCreate
        name: ca-certs
      - hostPath:
          path: /etc/ca-certificates
          type: DirectoryOrCreate
        name: etc-ca-certificates
    ```

    But you forgot the `-`

    ```yaml
      volumes:
      - hostPath:                    # <- note the difference
          path: /etc/ssl/certs
          type: DirectoryOrCreate
        name: ca-certs
      - hostPath:
          path: /etc/ca-certificates
          type: DirectoryOrCreate
        name: etc-ca-certificates
    ```

* Missing list where Kubernetes expects one

    ```
    (json: cannot unmarshal object into Go struct field PodSpec.spec.containers of type []v1.Container)
    ```

    Any unmarshalling error that mentions `type []...` (doesn't matter what comes after `[]`) means that a YAML list was expected but not found. In this particular case, it is telling us `PodSpec.spec.containers`, so it is complaining about the `containers:` section in your pod defintion not being a list. That means you probably did something like

    ```yaml
    spec:
      containers:
        name: nginx
        image: nginx
    ```

    When it should be

    ```yaml
    spec:
      containers:
      - name: nginx
        image: nginx
    ```

* Missing map where Kubernetes expects one

    ```
    (json: cannot unmarshal string into Go struct field Volume.spec.volumes.hostPath of type v1.HostPathVolumeSource)
    ```

    In this case, the error is caused by

    ```yaml
    volumes:
    - hostPath: /tmp
    ```

    We have specified a string `/tmp` for the value of `hostPath` when a YAML map is expected. These are represented as Go `struct` internally.

    It should have been

    ```yaml
    volumes:
    - hostPath:
        path: /tmp
    ```

* Argument error

    The YAML is correct. The spec structure is correct after it's been converted to JSON and marshalled, however the argument to a spec property is invalid.

    For instance, you've created a `volume` with type `File` or `Directory` which means that the indicated path must exist. If it does not, you will get an error similar to

    ```
    Error: MountVolume.SetUp failed for volume "audit" (UniqueName: "kubernetes.io/host-path/5a5fb26ce98b248d1257ea78eeb44853-audit") pod "kube-apiserver-controlplane" (UID: "5a5fb26ce98b248d1257ea78eeb44853") : hostPath type check failed: /etc/kubernetes/dev-audit.yaml is not a file
    ```

In general the categories of error fall under

* Incorrect indentation
* Misspelled or missing key
* Array when it should have been map
* Map when it should have been array
* Argument errors

**EXAM TIP**

While debugging a YAML file, have `vi` open in one terminal window and the command prompt in another. With each edit, save the file without exiting `vi`, using `:w`. Then in the other terminal run `kubectl create` or `kubectl apply` as appropriate until the command is successful. Then exit `vi`.

## Gotchas

Here we list any bugs in the GoLang YAML parser. By "bugs" we mean deviations from the [YAML 1.2 Standard](https://yaml.org/spec/1.2.2), whereby the parser does not behave as per the specification. These are traps for the unwary!

* Key duplication is not reported as an error.

    As per section [3.2.1.3](https://yaml.org/spec/1.2.2/#3213-node-comparison), a duplicate key should be reported as an error. Golang's parser (and thus `kubectl`) does not do this. Consider the following. Can you see the issue, and predict what will happen?

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: test
      name: test
    spec:
      volumes:
      - name: data
        emptyDir: {}
      containers:
      - image: nginx
        name: test
        resources:
          requests:
            cpu: 200m
        volumeMounts:
        - name: data
          mountPath: /data
        resources: {}
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    ```

    * What's wrong with the above?

      <details>
      <summary>Reveal</summary>

      `resources:` is defined twice. This should be reported as an error, but is not!

      </details>

    * What will happen?
      <details>
      <summary>Reveal</summary>

      The last value found for `resources` is what will go into the pod, therefore you may _think_ you set a CPU request, but in fact it will _not_ be set, and if that's for an exam question, then it won't score!

      Try creating a pod from the above, and get it back with

      ```
      kubectl get pod test -o yaml
      ```

      and note the lack of resources!

      Could be any key, and the one which is most likely to nip you (especially if you're doing CKS) would be `securityContext` which can be defined at container and pod level. If you do a container `securityContext`, then a pod one later in the manifest and get the indentation wrong, it would be interpreted as a second entry at container level and trump the first one.

      </details>

## YAML practice lab

A lecture and practice lab may be found in [this free course](https://kodekloud.com/courses/json-path-quiz/). Note that the lecture is taken from the Ansible course, however all the main concepts of YAML syntax are discussed.

## Advanced features

Note that you are not required to understand this for the exams. This section is provided just to demonstrate the power of YAML if you master it!

### Documents

A single YAML file may contain multiple documents. Each resource in Kubernetes is described by a single document. Multiple documents in the same file are separated by the document separator which is

```yaml
---
```

This means that you can declare for instance a deployment and a service to expose it in the same YAML file:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: nginx
  name: nginx
  namespace: default
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: nginx
  type: ClusterIP

```

### Aliases and Anchors
The GoLang YAML parser supports funky stuff like Aliases and Anchors, which help you to avoid repetition. Consider the case where you have a load of containers in a single pod, and they all require the same environment. You can do this:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-with-anchors
spec:
  containers:
  - name: c1
    image: nginx:1.14.2
    env: &environment             # <- anchor
    - name: MY_NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
  - name: c2
    image: nginx:1.14.2
    env: *environment             # <- alias (to above anchor)
  - name: c3
    image: nginx:1.14.2
    env: *environment
  - name: c4
    image: nginx:1.14.2
    env: *environment
  - name: c5
    image: nginx:1.14.2
    env: *environment
```

Apply this pod, then get it back with

```bash
kubectl get pod nginx-with-anchors -o yaml
```

You will see that the environment for c1 is replicated to all the other containers. Neat huh?


[Return to main FAQ](../README.md)