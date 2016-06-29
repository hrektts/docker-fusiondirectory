#!/usr/bin/env bats

@test "initialize" {
    run docker run --label bats-type="test" -p 80:80 \
        -e LDAP_DOMAIN="example.org" \
        -e LDAP_HOST="ldap.example.org" \
        -e LDAP_ADMIN_PASSWORD="password" \
        -d hrektts/fusiondirectory:bats
    [ "${status}" -eq 0 ]
    until curl --head localhost
    do
        sleep 1
    done
}

@test "cleanup" {
    CIDS=$(docker ps -q --filter "label=bats-type")
    if [ ${#CIDS[@]} -gt 0 ]; then
        run docker stop ${CIDS[@]}
        run docker rm ${CIDS[@]}
    fi
}
