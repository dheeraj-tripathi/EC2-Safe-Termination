#!/bin/bash
set -x

# This script runs pre-termination tasks, and sends a life cycle complete action
lifecycle_hook_name="EC2_Terminate_Lifecycle_Hook"
ec2_region=`curl http://169.254.169.254/latest/meta-data/placement/region/`
ec2_instanceid=`curl http://169.254.169.254/latest/meta-data/instance-id/`
asg_name=`aws ec2 describe-instances --instance-ids $ec2_instanceid --region us-west-2 --query "Reservations[0].Instances[0].Tags[?Key=='aws:autoscaling:groupName'].Value" --output text`

# Run all pre-termination tasks here, for now running some test commands
echo "`date +"%Y-%m-%d %T %Z"` .... Running pre-termination tasks on Instance - $ec2_instanceid , hostname - $(hostname) "

# Send complete lifecycle action
echo "ASG Name - $asg_name, sending lifecycle complete action "
aws autoscaling complete-lifecycle-action --lifecycle-hook-name $lifecycle_hook_name --auto-scaling-group-name $asg_name --instance-id $ec2_instanceid --lifecycle-action-result CONTINUE --region $ec2_region
