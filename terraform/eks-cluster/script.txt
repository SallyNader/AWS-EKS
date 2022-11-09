MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
sudo yum update
sudo yum install rsync
sudo mkdir /home/ec2-user/project

# Mounts nfs.
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport nfs-dns:/ /home/ec2-user/project

--==MYBOUNDARY==--