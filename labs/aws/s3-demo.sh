#!/bin/sh
set -eu

usage() {
    echo "Usage: $0 create|delete se-lab-unique-bucket-name" >&2
    exit 2
}

[ "$#" -eq 2 ] || usage
action=$1
bucket=$2

case "$bucket" in
    se-lab-*) ;;
    *) echo "Bucket name must begin with se-lab-." >&2; exit 2 ;;
esac

case "$action" in
    create)
        region=${AWS_REGION:-${AWS_DEFAULT_REGION:-us-east-1}}
        aws s3 mb "s3://$bucket" --region "$region"
        aws s3 cp labs/aws/hello.txt "s3://$bucket/hello.txt"
        aws s3 ls "s3://$bucket"
        ;;
    delete)
        aws s3 rm "s3://$bucket/hello.txt"
        aws s3 rb "s3://$bucket"
        ;;
    *)
        usage
        ;;
esac
