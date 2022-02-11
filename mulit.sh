#!/bin/bash

#workspaces=(`terraform workspace list | sed -r '/^$/d;/^.+default$/d;s/^[\* ]+(.+)$/\1/'`)
students=(`cat students.json | jq -r '. | @sh' | tr -d "'"`)

export TF_VAR_prefix='TEST_'

destory=1

count=0
for student in ${students[@]}; do
    
    workspace="${student}_$count"
    echo "Create ${workspace} for ${student} INDEX ${count}"

    terraform workspace select "${workspace}"
    workspace_exist=$?

    if (( $destory == 0 )); then
        if (( $workspace_exist != 0 )); then
            terraform workspace new "${workspace}"
        fi
        export TF_VAR_index="$count"
        export TF_VAR_student="${student}"
        #terraform plan && terraform apply -auto-approve
    elif (( $destory == 1 && $workspace_exist == 0 )); then
        export TF_VAR_index="$count"
        export TF_VAR_student="${student}"
        terraform plan -destroy
        terraform destroy -auto-approve
        terraform workspace select default
        terraform workspace delete "${workspace}" 
    fi

    (( count++ ))
done