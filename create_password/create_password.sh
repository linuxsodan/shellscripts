#!/bin/bash


# Generate a random password with at least one uppercase letter, one lowercase letter, and one digit
PASSWORD=$(</dev/urandom tr -dc 'A-Za-z0-9' | fold -w 10 | grep -E '.*[A-Z].*[a-z].*[0-9].*' | head -n 1)
#PASSWORD=$(</dev/urandom tr -dc 'A-Za-z0-9' | fold -w $1 | grep -E '.*[A-Z].*[a-z].*[0-9].*' | head -n 1)

echo "${PASSWORD}"
#echo "${PASSWORD}" | xsel -bi
