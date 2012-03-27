= Installing MongoDB

    # echo -e "\nInstalling MongoDB"
    # cat - > /etc/yum.repos.d/10gen-mongodb.repo <<EOF
    [10gen]
    name=10gen Repository
    baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64
    gpgcheck=0
    EOF

    # yum -y install mongo-10gen mongo-10gen-server
    # chkconfig --levels 235 mongod on

= Create Mongodb Pages Databases, objects collection

    # mongo
    > use pages
    > db.createCollection('objects')



