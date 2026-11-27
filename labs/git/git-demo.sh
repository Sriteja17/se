#!/bin/sh
set -eu

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT HUP INT TERM

cd "$workdir"
git init -q -b main
git config user.name "Lab Student"
git config user.email "student@example.invalid"

printf 'Hello from the main branch\n' > hello.txt
git add hello.txt
git commit -qm "Add greeting"

git switch -qc feature
printf 'A file from the feature branch\n' > feature.txt
git add feature.txt
git commit -qm "Add feature file"

git switch -q main
printf 'A file from the main branch\n' > main.txt
git add main.txt
git commit -qm "Add main file"
git merge --no-edit feature

printf '%s\n' '--- status ---'
git status --short --branch
printf '%s\n' '--- history ---'
git --no-pager log --oneline --graph --all
printf '%s\n' '--- file ---'
cat hello.txt
printf '%s\n' '--- merged files ---'
cat main.txt feature.txt
