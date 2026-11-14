#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck disable=SC2162
# shellcheck disable=SC2086
# shellcheck disable=SC2068
# shellcheck disable=SC2068
# shellcheck disable=SC2145
# shellcheck disable=SC2046
# shellcheck disable=SC1073
# shellcheck disable=SC1009
# shellcheck disable=SC1091
# shellcheck disable=SC2046
# shellcheck disable=SC2046
# shellcheck disable=SC1009


main () { 
    installer() {
        if ! command -v $@ &> /dev/null 2>&1; then
            sudo apt install -y $@
        else
            echo "[ INSTALL ] $@ installed"
        fi
    }


    dockerInstall() { 
        # uninstall all conflicting packages:
        sudo apt remove -y $(dpkg --get-selections docker.io docker-compose docker-doc docker-buildx podman-docker containerd runc | cut -f1) 
        # Installation methods:...
        # Add Docker GPG key:
        sudo apt update 
        sudo apt install ca-certificates curl 
        sudo install -m 0755 -d /etc/apt/keyrings 
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc 
        sudo chmod a+r /etc/apt/keyrings/docker.asc 
        # Add the repository to Apt resources: 
        sudo tee /etc/apt/sources.list.d/docker.sources <<EOF 
Types: deb 
URIs: https://download.docker.com/linux/debian 
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME") 
Components: stable 
Architectures: $(dpkg --print-architecture) 
Signed-By: /etc/apt/keyrings/docker.asc 
EOF

        sudo apt update 
        installer docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 
        if sudo systemctl status docker | grep -i "enable" || sudo service docker status | grep -i "running"; then 
            sudo systemctl enable docker && sudo systemctl start docker 
        fi 
    } 

    installer python3 curl


    python3 core/createDockerfile.py
    

    if ! command -v docker &> /dev/null 2>&1; then
        echo "[ Docker ]: Docker Not Exists"
        dockerInstall
    else
        echo "[ Docker ]: Ready To Use"
    fi
    
    CONTAINER_NAME=$(docker ps --format "{{.Names}}" | grep -i tsk)

    if [[ "$CONTAINER_NAME" ]]; then
        echo "tsk container is working; stoping tsk container"
        sudo docker compose down
        echo "Running Please Wait a moment"
        eval $(python3 core/dchange.py)
        echo "Contanier Activated Run your browser"
    else
        echo "Running Please Wait a moment"
        eval $(python3 core/dchange.py)
        echo "Contanier Activated Run your browser"
    fi
} 

echo  "Running this program requires Debian version 11, 12, or 13. Do you wish to proceed? (n / y):"
read  question
if [[  "$question" == "y"  ]] || [[ "$question" == "Y" ]]; then 
    main 
else 
    echo "See you soon" 
    exit 1 
fi 
