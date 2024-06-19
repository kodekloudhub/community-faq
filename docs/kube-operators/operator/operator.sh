#!/usr/bin/env bash
#
# Simulation of a operator acting as a resource controller
#
# Here we have a custom resource "BashReplicaSet", that is to all intents and purposes the same as a real ReplicaSet
# so it manages a number of running pods.
#
# This is very basic and by no means coveres everything that a controller operator does for real.
# It simply ensures the number of running pods matches the replica count in the resource spec.

# Reconcilication loop - watching for changes to any instance of the custom resource BashReplicaSet
echo "Watching for changes..."

while true
do
    # Iterate the custom resources across all namespaces
    for custom_resource in $(kubectl get BashReplicaSet -A -o jsonpath='{range .items[*]}{.metadata.namespace}/{.metadata.name}{end}' 2>/dev/null)
    do
        # Get the namespace and custom resource name
        namespace=$(cut -d / -f 1 <<< $custom_resource)
        resource=$(cut -d / -f 2 <<< $custom_resource)

        # Calculate a pod template hash from the pod template in the custom resource
        h=$(kubectl get BashReplicaSet -n $namespace $resource -o jsonpath='{.spec.template}' | md5sum)
        pod_template_hash=${h:0:10}

        # Get the number of replicas there should be
        replicas=$(kubectl get BashReplicaSet -n $namespace $resource -o jsonpath='{.spec.replicas}')

        # Build a selector for pods from the custom resource's matchLabels
        # Output resource as JSON, then
        # - jq expression turns "app: nginx" into "app=nginx"
        # - awk will join multiple labels into a comma list, e.g. "app=nginx,foo=bar"
        # - sed will remove any trailing ','
        selector=$(kubectl get BashReplicaSet -n $namespace $resource -o json | jq -r '.spec.selector.matchLabels | to_entries[] | join("=")' | awk -vORS=, '{ print $1 }' | sed 's/,$/\n/')

        # Check if we have the right number of pods
        pod_count=$(kubectl get pods -n $namespace --selector $selector --no-headers 2>/dev/null | wc -l)

        # If we have the right number of replicas, then move on
        [ $pod_count -eq $replicas ] && continue

        # Replica count is not the desired number
        echo "Desired = $replicas, Actual = $pod_count"

        # Calculate difference between desired and actual number of pods
        # If the difference is positive, add pods. If negative, delete pods.
        difference=$(( $replicas - $pod_count ))

        if [ $difference -gt  0 ]
        then
            # We need to create this number of pods
            # Controller uses the template given in the BashReplicaSet spec section
            # and adds custom metadata, which will include a name for the pod, a pod-template-hash
            # and an ownerReference block to say who onws the pod.
            # The relationship between onwerReference and its owner is that the uid value of the custom resource
            # is present in the ownerReference in the running pod. This is the main reason for all resources having a uid,
            # so that they can be owned by other resources and a dependency relationship created.
            #
            # If the BashReplicaSet resource is deleted, it will also delete any pods whose ownerReference is the BashReplicaSet which is desired behaviour.

            # get UID of the BashReplicaSet for owner reference
            uid=$(kubectl get BashReplicaSet -n $namespace $resource -o jsonpath='{.metadata.uid}')

            # Get the pod spec into a temporary JSON file
            kubectl get BashReplicaSet -n $namespace $resource -o jsonpath='{.spec.template}' > /tmp/pod.spec

            for pod_no in $(seq 1 $difference)
            do
                # generate random 5 character suffix for pod name
                suffix=$(tr -dc a-z0-9 </dev/urandom 2>/dev/null | head -c 5)

                # Create JSON to merge into the pod spec to make it a valid pod spec
                # Need to add apiVersion and kind, along with a label we can use to identify the pods we create (the template hash),
                # and the ownerReference details so that kubernetes will delete the pods if the BashReplicaSet itself is deleted.
                echo '{"apiVersion": "v1", "kind": "Pod", "metadata": {"name": "'${resource}-${suffix}'", "labels": {"pod-template-hash": "'${pod_template_hash}'"}, "ownerReferences": [{"apiVersion": "example.com/v1", "kind": "BashReplicaSet", "name": "'$resource'", "uid": "'$uid'"}]}}' > /tmp/$pod_hash.meta

                # Merge template with stuff created in the line above
                jq -s '.[0] * .[1]' /tmp/pod.spec /tmp/$pod_hash.meta > /tmp/new-pod.json

                # Create the pod
                kubectl apply -n $namespace -f /tmp/new-pod.json

                # Clean temp files for pod
                rm /tmp/$pod_hash.meta /tmp/new-pod.json
            done

            # Clean temp file holding pod template
            rm /tmp/pod.spec

        elif [ $difference -lt 0 ]
        then
            # We need to delete this number of pods
            # Make the number positive
            difference=$(( 0 - $difference ))

            # Now select the names of "difference" number of pods and delete them.
            for pod in $(kubectl get pods -n $namespace --selector $selector -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | head -${difference})
            do
                kubectl delete pod -n $namespace $pod
            done
        fi

        echo "Watching for changes..."
    done
done