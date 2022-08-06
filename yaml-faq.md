# YAML FAQ

We see a few questions about "kubectl" YAML manifests and what you can and can't do syntactically, therefore we'll try to clear some of this up.

`kubectl` (and anything else in the ecosystem that needs to read YAML like `kubelet` etc) is built using the standard GoLang YAML package, which apart from anything explicitly mentioned in the package's [Compatibility](https://github.com/go-yaml/yaml#compatibility) paragraph is YAML 1.2 compliant, and this is the dialect that `kubectl` understands. There is no "special" `kubectl` dialect.

* [In a nutshell](#in-a-nutshell)
* [To quote or not to quote](#to-quote-or-not-to-quote)
* [Indentation](#indentation)
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


## To quote or not to quote

YAML always parses literal values as strings, unless the value is wholly numeric (including canonical, integer, fixed point, exponential, octal or hex), a timestamp or a boolean: `true`, `false`, `yes`, `no`. If you want to force a non-string to be parsed as a string, you must quote it. This rule applies to environment variable values and to command arguments which must both be passed to the underlying container as a string, hence

```yaml
command:
- sleep
- "4800"
```

We've seen posts that say "You must quote mount paths" or "You must quote pod capabilities". This isn't case, at least not with later versions of the tools. This may have been so with older versions where they may have been using a less mature version of the GoLang YAML parser. At the end of the day you want to use as few keystrokes as possible when doing the exam!

## Indentation

Beware of the pesky indentation rules. Whitespace is part of the syntax like Python, however `TAB` characters are not.

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

## Aliases and Anchors
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

