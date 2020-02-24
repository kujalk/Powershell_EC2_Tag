<#
Purpose - To stop/start AWS EC2 instances using tag values
Developer - K.Janaarthanan
Date - 24/02/2020

Pre-Requests
-------------
1. AWS PowerShell Tools installed
2. Make sure you have user account with programmatic access and issue the below command to create a AWS User profile
   Set-AWSCredential -AccessKey xxxxx -SecretKey xxxxx -StoreAs MyNewProfile
#>


$profile_name=Read-Host "Provide your AWS profile Name"

Get-AWSRegion | Out-String

$region=Read-Host "Please provide your AWS region"

Initialize-AWSDefaultConfiguration -ProfileName $profile_name -Region $region

$all_instances=Get-EC2Instance | Select-Object Instances -ExpandProperty Instances

$tag_key=Read-Host "Provide the Tag Key"
$tag_value=Read-Host "Provide the Tag Value"
$operation=Read-Host "start/stop"

foreach ($instance in $all_instances)
{

    if(($instance.Tags.Key -eq $tag_key) -and ($instance.Tags.Value -eq $tag_value))
    {

    write-host "Instance ID "$instance.InstanceID "Key:" $instance.Tags.Key "Value:" $instance.Tags.Value
    if ($operation -eq "start")
    {
        if($instance.State.Name.Value -eq "stopped")
        {
            $action=$instance | Start-EC2Instance
            write-host "Starting "$instance.InstanceID
        }

        else
        {
            write-Host "No action needed for" $instance.InstanceID
        }
    }

    if ($operation -eq "stop")
    {
        if($instance.State.Name.Value -eq "running")
        {
            $action=$instance | Stop-EC2Instance
            write-host "Stopping "$instance.InstanceID
        }

        else
        {
            write-Host "No action needed for" $instance.InstanceID
        }
    }
    }
}