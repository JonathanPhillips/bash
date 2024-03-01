# Change directories and ls 
function cl() {
    DIR="$*";
        # if no DIR given, go home
        if [ $# -lt 1 ]; then
                DIR=$HOME;
    fi;
    builtin cd "${DIR}" && \
    # use your preferred ls command
        ls -F --color=auto
}

# AWS SSO
function sso() {
        aws --profile sso-$1 sso login
}

# AWS List S3 Buckets in Account
function s3() {
        aws s3 ls --profile sso-$1 --region us-east-1
}

# AWS Describe EC2 in Account
function ec2() {
        aws ec2 describe-instances --profile sso-$1 --region us-east-1 | jq -r '.Reservations[].Instances[] | .InstanceId + " " + .InstanceType + " " + (.Tags | from_entries | .Name // "N/A")'
}

# AWS List VPCs and CIDRs
function vpc() {
        aws ec2 describe-vpcs --profile sso-$1 --region us-east-1 | jq -r '.Vpcs[]|.VpcId+" "+(.Tags[]|select(.Key=="Name").Value)+" "+.CidrBlock'
}

# AWS list DynamoDB tables
function ddb() {
        aws dynamodb list-tables --profile sso-$1 --region us-east-1 | jq -r .TableNames
}

# AWS List Security Groups
function sg() {
        aws ec2 describe-security-groups --profile sso-$1 --region us-east-1 | jq -r '.SecurityGroups[]|.GroupId+" "+.GroupName'
}

# AWS List Target Groups
function tg() {
        aws elbv2 describe-target-groups --profile sso-$1 --region us-east-1 | jq -r '.TargetGroups[] | .TargetGroupArn'
}

# AWS List ELB ARNs
function elb-arn() {
        aws elbv2 describe-load-balancers --profile sso-$1 --region us-east-1 | jq -r '.LoadBalancers[] | .LoadBalancerArn'
}

# AWS List ELB Hostnames
function elb-dns() {
        aws elbv2 describe-load-balancers --profile sso-$1 --region us-east-1 --query 'LoadBalancers[*].DNSName' | jq -r 'to_entries[] | .value'
}

# AWS Start SSM Session
function ssm() {
        aws ssm start-session --profile sso-$1 --region us-east-1 --target "$2"
}

# export AWS_PROFILE
function exp() {
        export AWS_PROFILE=sso-$1
}
