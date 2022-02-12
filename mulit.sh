#!/bin/bash

db_path='./students.json'

if [ -f "$db_path" ]; then
    students=(`cat $db_path | jq -r '. | @sh' | tr -d "'"`)
else
    echo "\"$db_path\" does not exist."
    exit 1
fi

if (( ${#students[@]} < 1 )); then
    echo "There are no students in $db_path or it is not valid."
    exit 1
fi

if (( ${#TF_VAR_prefix} == 0 )); then
    echo "Env \"TF_VAR_prefix\" is empty."
    exit 1
elif (( ${#TF_VAR_vsphere_password} == 0 )); then
    echo "Env \"TF_VAR_vsphere_password\" is empty."
    exit 1
elif (( ${#TF_VAR_nsxt_password} == 0 )); then
    echo "Env \"TF_VAR_vsphere_password\" is empty."
    exit 1
fi

if [[ "$1" == "-destroy" ]]; then
    echo "All of these will be destroyed:"
    terraform workspace list | sed '/^$/d;/^[ \*\t]*default$/d'
    echo -e "\e[31mDESTROY EVERYTHING!!\e[0m"
    # Are you sure??
    read -p "Continue (yes/no)? " CONT
    [ "$CONT" != "yes" ] && exit 0 
    destory=1
else
    destory=0
fi

count=0
for student in ${students[@]}; do
    
    workspace="${student}_$count"
    terraform workspace select "${workspace}" 2>/dev/null
    workspace_exist=$?

    if (( $destory == 0 )); then
        if (( $workspace_exist != 0 )); then
            terraform workspace new "${workspace}"
        fi

        export TF_VAR_index="$count"
        export TF_VAR_student="${student}"

        echo -e "\e[32mCreate ${workspace} for ${student} -> \e[31;1m#${count}\e[0m"
        (
            terraform plan >/dev/null && \
            terraform apply -auto-approve
        ) && echo -e "\e[32mCreated!\e[0m"

    elif (( $destory == 1 && $workspace_exist == 0 )); then

        export TF_VAR_index="$count"
        export TF_VAR_student="${student}"

        echo -e "\e[32mDestroy ${workspace} for ${student} -> \e[31;1m#${count}\e[0m"
        (
            terraform plan -destroy >/dev/null && \
            terraform destroy -auto-approve && \
            terraform workspace select default >/dev/null && \
            terraform workspace delete "${workspace}" 
        ) && echo -e "\e[32mCreated!\e[0m"
    fi

    (( count++ ))
done