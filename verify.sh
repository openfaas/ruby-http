#!/bin/bash
set -e

CLI="faas-cli"

build_template() {
    template=$1

    echo Building $template
    func_name=$template-ci
    $CLI new $func_name --lang $template 2>/dev/null 1>&2
    $CLI build -f stack.yaml
}

verify_and_clean() {
    image=$1
    tag_name=latest

    echo Verifying $template
    container=$(docker run -d -p 8080:8080 $func_name:$tag_name)
    sleep 5 # wait for slower templates to start
    output=$(curl -s -d "testing" http://127.0.0.1:8080)

    echo $image output: $output
    success=false
    if [ ! -z "$output" ]; then # output was not empty = good template
        success=true
    fi

    echo Cleaning $image
    docker rm $container -f 2>/dev/null 1>&2
    docker rmi $func_name:$tag_name 2>/dev/null 1>&2

    if [ "$success" = false ]; then
        echo $image template failed validation
        exit 1
    else
        echo $image template validation successful
    fi
}

tmpdir=$(mktemp -d -t openfaas-XXXXXX)
trap 'rm -rf $tmpdir' EXIT
cp -r ./template $tmpdir

if ! [ -x "$(command -v faas-cli)" ]; then
    mkdir -p $tmpdir/bin
    cd $tmpdir/bin

    curl -sSL https://cli.openfaas.com | sh
    CLI="$tmpdir/bin/faas-cli"
fi

cli_version=$($CLI version --short-version)

echo Validating templates with faas-cli $cli_version

# verify each of the templates
cd $tmpdir/template
for dir in ./*/; do
    dirname=${dir%*/}
    template=${dirname##*/}

    # skip arm templates
    case "$template" in
    *-arm*) continue ;;
    esac

    pushd ../ 2>/dev/null 1>&2

    build_template $template
    verify_and_clean $template

    popd 2>/dev/null 1>&2
done
