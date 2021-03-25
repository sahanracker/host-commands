#!/bin/bash
#title:         host_commands.sh
#description:   Execute multiple host commands using AWS SSM
#author:        Sahan Perera
#created:       Mar 7 2021
#updated:       Mar 7 2021
#version:       V0.1
#Git    :       https://github.com/sahanracker/host-commands
#usage:         ./host_commands.sh
#==============================================================================

source ./variable.txt
lines=`cat ./$AccountId.txt`

echo "Start the program  at $(date -u) \n"
echo "============================================================================================"
echo "Hostname, Instance ID , Host Command output , Tags" >> output.csv
for line in $lines ; do
    instance_id=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$line" --region $region  --query 'Reservations[].Instances[].InstanceId' --output text)
    
    echo "  Gathering install detail of [Hostname:$line | InstanceID:$instance_id ] "
    echo "========================================================================================="
    #commandlist=["df -h","echo ****_print_etc_host_****","cat /etc/hosts"]
    tag_command=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance_id" --query  'Tags[].{Key:Key,Value:Value}' --region $region --output json)
    echo $tag_command
    command=$(aws ssm send-command --document-name "AWS-RunShellScript" --comment "Check df -h on $instance_id" --instance-ids $instance_id --parameters commands=["df -h","echo ****_print_etc_host_****","cat /etc/hosts"] --region $region --output text)
    cmdId=$(echo $command | awk '{print $2}')
    
    echo $cmdId
    while [ "$(aws ssm list-command-invocations --command-id "$cmdId" --query "CommandInvocations[].Status" --output text --region $region )" == "Pending"  ]; do sleep 1; done
    output=$(aws ssm list-command-invocations --command-id "$cmdId" --details --query "CommandInvocations[*].CommandPlugins[*].Output[]" --region $region --output json)
    echo $output
    echo "$line,$instance_id,$output,$tag_command, " >> output.csv
done
echo "Finish the program at $(date -u) \n"
