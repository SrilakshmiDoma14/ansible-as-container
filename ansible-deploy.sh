#!/bin/bash

create_container () {
   docker build -t tfimage:latest .
   docker run -it -d --name tfcontainer1 -v /root/.ssh:/root/.ssh tfimage:latest
   docker exec -i tfcontainer1 bash -c 'cd /root/Code/Ansible &&
   ansible-playbook -i a-invt web.yml &&
   exit; exec "${SHELL:-sh}"'
   docker stop tfcontainer1
   docker rm tfcontainer1
   docker rmi tfimage:latest
}

filename='ip.txt'

if [ -d "/root/.ssh" ]; then
   while read ip; do
      echo "******$ip******"
      echo "Key already exists in host machine "

      status=$(ssh -o BatchMode=yes -o ConnectTimeout=5 ansible@$ip echo ok 2>&1)

      if [[ $status != ok ]] ; then
         echo "****** No SSH Keys. Generating SSH keys ******"
         sshpass -p "ansible123" ssh-copy-id -o StrictHostKeyChecking=no ansible@$ip
      fi
   done < $filename
else

   echo "****** No SSH Keys. Generating SSH keys ******"
   printf '\n' | ssh-keygen -N ''
   while read ip; do
      echo "****$ip*****"
       sshpass -p "ansible123" ssh-copy-id -o StrictHostKeyChecking=no ansible@$ip
   done < $filename
fi
create_container
