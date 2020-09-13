cd $HOME/guide
docker stop `docker ps -a | grep 'hyperledger' | gawk '{print $1}'`
docker rm `docker ps -a | grep 'hyperledger' | gawk '{print $1}'`
sudo rm -rf /tmp/hyperledger/*
cd $HOME/guide



echo "#####################################"
echo " "
echo "Docker Bootstrap tls-ca"
echo " "
echo "#####################################"
docker-compose   up -d --no-deps ca-tls
docker-compose   start ca-tls
cd /tmp/
sudo chown -R lab:lab *
#mv /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem

echo "#####################################"
echo " "
echo "Enroll TLS CA's Admin"
echo " "
echo "#####################################"
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/tls/ca/admin
fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@0.0.0.0:7052

# peers and orderers of fabric network register
# Org1
fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name peer2-org1 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7052
# Org2
fabric-ca-client register -d --id.name peer1-org2 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7052

# Orderer
fabric-ca-client register -d --id.name orderer1-org0 --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer2-org0 --id.secret orderer2PW --id.type orderer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer3-org0 --id.secret orderer3PW --id.type orderer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer4-org0 --id.secret orderer4PW --id.type orderer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer5-org0 --id.secret orderer5PW --id.type orderer -u https://0.0.0.0:7052


echo "###############################################"
echo " "
echo "Docker Bootstrap rca-org0 rca-org1 rca-org2"
echo " "
echo "##############################################"
cd $HOME/guide
docker-compose   up -d --no-deps rca-org0 rca-org1 rca-org2
docker-compose   start rca-org0 rca-org1 rca-org2
cd /tmp/ && sudo chown -R lab:lab *

# Enroll Orderer Org's CA Admin
echo "#####################################"
echo " "
echo "Enroll Orderer Org's CA Admin"
echo " "
echo "#####################################"
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/ca/admin
fabric-ca-client enroll -d -u https://rca-org0-admin:rca-org0-adminpw@0.0.0.0:7053

# register admin and orderers of Org0 from Org0's Root CA
fabric-ca-client register -d --id.name orderer1-org0 --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name orderer2-org0 --id.secret orderer2pw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name orderer3-org0 --id.secret orderer3pw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name orderer4-org0 --id.secret orderer4pw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name orderer5-org0 --id.secret orderer5pw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name admin-org0 --id.secret org0adminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7053


# Enroll Org1's CA
echo "#####################################"
echo " "
echo "Enroll Org1's CA Admin"
echo " "
echo "#####################################"
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/ca/admin
fabric-ca-client enroll -d -u https://rca-org1-admin:rca-org1-adminpw@0.0.0.0:7054

# register peers ,admin, user of Org1 from Org1's Root CA
fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name peer2-org1 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name admin-org1 --id.secret org1AdminPW --id.type user --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name user-org1 --id.secret org1UserPW --id.type user -u https://0.0.0.0:7054

# Enroll Org2's CA
echo "#####################################"
echo " "
echo "Enroll Org2's CA Admin"
echo " "
echo "#####################################"
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/ca/admin
fabric-ca-client enroll -d -u https://rca-org2-admin:rca-org2-adminpw@0.0.0.0:7055

# register peers ,admin, user of Org2 from Org2's Root CA
fabric-ca-client register -d --id.name peer1-org2 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7055
fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7055
fabric-ca-client register -d --id.name admin-org2 --id.secret org2AdminPW --id.type user --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7055
fabric-ca-client register -d --id.name user-org2 --id.secret org2UserPW --id.type user -u https://0.0.0.0:7055


# 각 peer들에게 해당 조직의 ca와 tls-ca의 인증서를 넘깁니다.
sudo chown -R lab:lab *
# Org1
mkdir -p /tmp/hyperledger/org1/peer1/assets/ca/
mkdir -p /tmp/hyperledger/org1/peer1/assets/tls-ca

mkdir -p /tmp/hyperledger/org1/peer2/assets/ca/
mkdir -p /tmp/hyperledger/org1/peer2/assets/tls-ca

# Org2
mkdir -p /tmp/hyperledger/org2/peer1/assets/ca/
mkdir -p /tmp/hyperledger/org2/peer1/assets/tls-ca

mkdir -p /tmp/hyperledger/org2/peer2/assets/ca/
mkdir -p /tmp/hyperledger/org2/peer2/assets/tls-ca


# Org1
cp /tmp/hyperledger/org1/ca/crypto/ca-cert.pem /tmp/hyperledger/org1/peer1/assets/ca/org1-ca-cert.pem
cp /tmp/hyperledger/org1/ca/crypto/ca-cert.pem /tmp/hyperledger/org1/peer2/assets/ca/org1-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org1/peer1/assets/tls-ca/tls-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org1/peer2/assets/tls-ca/tls-ca-cert.pem

# Org2
cp /tmp/hyperledger/org2/ca/crypto/ca-cert.pem /tmp/hyperledger/org2/peer1/assets/ca/org2-ca-cert.pem
cp /tmp/hyperledger/org2/ca/crypto/ca-cert.pem /tmp/hyperledger/org2/peer2/assets/ca/org2-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org2/peer1/assets/tls-ca/tls-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org2/peer2/assets/tls-ca/tls-ca-cert.pem


echo "#####################################"
echo " "
echo "Enroll Org1's Peer1"
echo " "
echo "#####################################"

# CA에 org1's peer1 enroll
#TLS CERTIFICATE로 해당 TLS CA가 아닌 CA의 인증서를 지정해줍니다.(CA에게 enroll하는 과정이기 때문)
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer1/assets/ca/org1-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org1:peer1PW@0.0.0.0:7054
 
# tls-ca에 org1's peer1 enroll 
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer1/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org1:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-org1
mv /tmp/hyperledger/org1/peer1/tls-msp/keystore/* /tmp/hyperledger/org1/peer1/tls-msp/keystore/key.pem


echo "#####################################"
echo " "
echo "Enroll Org1's Peer2"
echo " "
echo "#####################################"
export FABRIC_CA_CLIENT_MSPDIR=msp
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer2/assets/ca/org1-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org1:peer2PW@0.0.0.0:7054

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer2/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org1:peer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-org1
mv /tmp/hyperledger/org1/peer2/tls-msp/keystore/* /tmp/hyperledger/org1/peer2/tls-msp/keystore/key.pem



echo "#####################################"
echo " "
echo "Enroll Org1's Admin"
echo " "
echo "#####################################"
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer1/assets/ca/org1-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org1:org1AdminPW@0.0.0.0:7054
cp -r /tmp/hyperledger/org1/admin/msp/signcerts /tmp/hyperledger/org1/admin/msp/admincerts

mkdir /tmp/hyperledger/org1/peer1/msp/admincerts
cp /tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /tmp/hyperledger/org1/peer1/msp/admincerts/org1-admin-cert.pem

mkdir /tmp/hyperledger/org1/peer2/msp/admincerts
cp /tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /tmp/hyperledger/org1/peer2/msp/admincerts/org1-admin-cert.pem

cd $HOME/guide
docker-compose   up -d --no-deps peer1-org1
docker-compose   up -d --no-deps peer2-org1
docker-compose   start peer1-org1 peer2-org1

echo "#####################################"
echo " "
echo "Enroll Org2's Peer1"
echo " "
echo "#####################################"
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/peer1/assets/ca/org2-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org2:peer1PW@0.0.0.0:7055

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/peer1/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org2:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-org2
mv /tmp/hyperledger/org2/peer1/tls-msp/keystore/* /tmp/hyperledger/org2/peer1/tls-msp/keystore/key.pem


echo "#####################################"
echo " "
echo "Enroll Org2's Peer2"
echo " "
echo "#####################################"
export FABRIC_CA_CLIENT_MSPDIR=msp
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/peer2/assets/ca/org2-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org2:peer2PW@0.0.0.0:7055

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/peer2/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org2:peer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-org2
mv /tmp/hyperledger/org2/peer2/tls-msp/keystore/* /tmp/hyperledger/org2/peer2/tls-msp/keystore/key.pem


echo "#####################################"
echo " "
echo "Enroll Org2's Admin"
echo " "
echo "#####################################"
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/peer1/assets/ca/org2-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org2:org2AdminPW@0.0.0.0:7055

cp -r /tmp/hyperledger/org2/admin/msp/signcerts /tmp/hyperledger/org2/admin/msp/admincerts

mkdir /tmp/hyperledger/org2/peer1/msp/admincerts
cp /tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /tmp/hyperledger/org2/peer1/msp/admincerts/org2-admin-cert.pem

mkdir /tmp/hyperledger/org2/peer2/msp/admincerts
cp /tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /tmp/hyperledger/org2/peer2/msp/admincerts/org2-admin-cert.pem


cd $HOME/guide
docker-compose   up -d --no-deps peer1-org2
docker-compose   up -d --no-deps peer2-org2
docker-compose   start peer1-org2 peer2-org2


echo "#####################################"
echo " "
echo "Enroll Orderer"
echo " "
echo "#####################################"


# orderer 1
mkdir -p /tmp/hyperledger/org0/orderer/assets/ca
mkdir -p /tmp/hyperledger/org0/orderer/assets/tls-ca
cp /tmp/hyperledger/org0/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem

export FABRIC_CA_CLIENT_MSPDIR=msp
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/orderer
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1-org0:ordererpw@0.0.0.0:7053
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1-org0:ordererPW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer1-org0
mv /tmp/hyperledger/org0/orderer/tls-msp/keystore/* /tmp/hyperledger/org0/orderer/tls-msp/keystore/key.pem




# orderer 2
mkdir -p /tmp/hyperledger/org0/orderer2/assets/ca
mkdir -p /tmp/hyperledger/org0/orderer2/assets/tls-ca
cp /tmp/hyperledger/org0/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer2/assets/ca/org0-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer2/assets/tls-ca/tls-ca-cert.pem

export FABRIC_CA_CLIENT_MSPDIR=msp
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/orderer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer2/assets/ca/org0-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer2-org0:orderer2pw@0.0.0.0:7053
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer2-org0:orderer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer2-org0
mv /tmp/hyperledger/org0/orderer2/tls-msp/keystore/* /tmp/hyperledger/org0/orderer2/tls-msp/keystore/key.pem


# orderer 3
mkdir -p /tmp/hyperledger/org0/orderer3/assets/ca
mkdir -p /tmp/hyperledger/org0/orderer3/assets/tls-ca
cp /tmp/hyperledger/org0/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer3/assets/ca/org0-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer3/assets/tls-ca/tls-ca-cert.pem

export FABRIC_CA_CLIENT_MSPDIR=msp
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/orderer3
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer3/assets/ca/org0-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer3-org0:orderer3pw@0.0.0.0:7053
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer3-org0:orderer3PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer3-org0
mv /tmp/hyperledger/org0/orderer3/tls-msp/keystore/* /tmp/hyperledger/org0/orderer3/tls-msp/keystore/key.pem

# orderer 4
mkdir -p /tmp/hyperledger/org0/orderer4/assets/ca
mkdir -p /tmp/hyperledger/org0/orderer4/assets/tls-ca
cp /tmp/hyperledger/org0/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer4/assets/ca/org0-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer4/assets/tls-ca/tls-ca-cert.pem

export FABRIC_CA_CLIENT_MSPDIR=msp
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/orderer4
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer4/assets/ca/org0-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer4-org0:orderer4pw@0.0.0.0:7053
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer4/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer4-org0:orderer4PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer4-org0
mv /tmp/hyperledger/org0/orderer4/tls-msp/keystore/* /tmp/hyperledger/org0/orderer4/tls-msp/keystore/key.pem

# orderer 5
mkdir -p /tmp/hyperledger/org0/orderer5/assets/ca
mkdir -p /tmp/hyperledger/org0/orderer5/assets/tls-ca
cp /tmp/hyperledger/org0/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer5/assets/ca/org0-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer5/assets/tls-ca/tls-ca-cert.pem

export FABRIC_CA_CLIENT_MSPDIR=msp
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/orderer5
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer5/assets/ca/org0-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer5-org0:orderer5pw@0.0.0.0:7053
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer5/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer5-org0:orderer5PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer5-org0
mv /tmp/hyperledger/org0/orderer5/tls-msp/keystore/* /tmp/hyperledger/org0/orderer5/tls-msp/keystore/key.pem

echo "#####################################"
echo " "
echo "Enroll Org0's Admin"
echo " "
echo "#####################################"

export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org0:org0adminpw@0.0.0.0:7053
cp -r /tmp/hyperledger/org0/admin/msp/signcerts /tmp/hyperledger/org0/admin/msp/admincerts

# 각 orderer들에게 admin의 인증서를 넘깁니다.
mkdir /tmp/hyperledger/org0/orderer/msp/admincerts
cp /tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /tmp/hyperledger/org0/orderer/msp/admincerts/orderer-admin-cert.pem
mkdir /tmp/hyperledger/org0/orderer2/msp/admincerts
cp /tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /tmp/hyperledger/org0/orderer2/msp/admincerts/orderer-admin-cert.pem
mkdir /tmp/hyperledger/org0/orderer3/msp/admincerts
cp /tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /tmp/hyperledger/org0/orderer3/msp/admincerts/orderer-admin-cert.pem
mkdir /tmp/hyperledger/org0/orderer4/msp/admincerts
cp /tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /tmp/hyperledger/org0/orderer4/msp/admincerts/orderer-admin-cert.pem
mkdir /tmp/hyperledger/org0/orderer5/msp/admincerts
cp /tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /tmp/hyperledger/org0/orderer5/msp/admincerts/orderer-admin-cert.pem



echo "#####################################"
echo " "
echo "Create Genesis Block and Channel Transaction"
echo " "
echo "#####################################"

mkdir /tmp/hyperledger/org0/msp
mkdir /tmp/hyperledger/org0/msp/admincerts
mkdir /tmp/hyperledger/org0/msp/cacerts
mkdir /tmp/hyperledger/org0/msp/tlscacerts
mkdir /tmp/hyperledger/org0/msp/users
cp /tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /tmp/hyperledger/org0/msp/admincerts/admin-org0-cert.pem
cp /tmp/hyperledger/org0/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/msp/cacerts/org0-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/msp/tlscacerts/tls-ca-cert.pem

mkdir /tmp/hyperledger/org1/msp
mkdir /tmp/hyperledger/org1/msp/admincerts
mkdir /tmp/hyperledger/org1/msp/cacerts
mkdir /tmp/hyperledger/org1/msp/tlscacerts
mkdir /tmp/hyperledger/org1/msp/users
cp /tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /tmp/hyperledger/org1/msp/admincerts/admin-org1-cert.pem
cp /tmp/hyperledger/org1/ca/crypto/ca-cert.pem /tmp/hyperledger/org1/msp/cacerts/org1-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org1/msp/tlscacerts/tls-ca-cert.pem

mkdir /tmp/hyperledger/org2/msp
mkdir /tmp/hyperledger/org2/msp/admincerts
mkdir /tmp/hyperledger/org2/msp/cacerts
mkdir /tmp/hyperledger/org2/msp/tlscacerts
mkdir /tmp/hyperledger/org2/msp/users
cp /tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /tmp/hyperledger/org2/msp/admincerts/admin-org2-cert.pem
cp /tmp/hyperledger/org2/ca/crypto/ca-cert.pem /tmp/hyperledger/org2/msp/cacerts/org2-ca-cert.pem
cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/org2/msp/tlscacerts/tls-ca-cert.pem


# genesis block 및 channel.tx 생성
export PATH=$PATH:$GOPATH/src/github.com/hyperledger/fabric-samples/bin
export FABRIC_CFG_PATH=$HOME/guide
configtxgen -profile OrgsOrdererGenesis -outputBlock /tmp/hyperledger/org0/orderer/genesis.block
configtxgen -profile OrgsChannel -outputCreateChannelTx /tmp/hyperledger/org0/orderer/channel.tx -channelID mychannel

# 생성한 genesis.block 나머지 orderer들에게 넘기기
cp /tmp/hyperledger/org0/orderer/genesis.block /tmp/hyperledger/org0/orderer2/
cp /tmp/hyperledger/org0/orderer/genesis.block /tmp/hyperledger/org0/orderer3/
cp /tmp/hyperledger/org0/orderer/genesis.block /tmp/hyperledger/org0/orderer4/
cp /tmp/hyperledger/org0/orderer/genesis.block /tmp/hyperledger/org0/orderer5/

# 생성한 channel.tx 나머지 orderer들에게 넘기기
cp /tmp/hyperledger/org0/orderer/channel.tx /tmp/hyperledger/org0/orderer2/
cp /tmp/hyperledger/org0/orderer/channel.tx /tmp/hyperledger/org0/orderer3/
cp /tmp/hyperledger/org0/orderer/channel.tx /tmp/hyperledger/org0/orderer4/
cp /tmp/hyperledger/org0/orderer/channel.tx /tmp/hyperledger/org0/orderer5/

# orderer들 부팅
cd $HOME/guide
docker-compose   up -d --no-deps orderer1-org0
docker-compose   start orderer1-org0

docker-compose   up -d --no-deps orderer2-org0
docker-compose   start orderer2-org0
docker-compose   up -d --no-deps orderer3-org0
docker-compose   start orderer3-org0
docker-compose   up -d --no-deps orderer4-org0
docker-compose   start orderer4-org0
docker-compose   up -d --no-deps orderer5-org0
docker-compose   start orderer5-org0
docker-compose   up -d --no-deps cli-org1 cli-org2
docker-compose   start cli-org1 cli-org2


echo "#####################################"
echo " "
echo "Create and Join Channel"
echo " "
echo "#####################################"

cp /tmp/hyperledger/org0/orderer/channel.tx /tmp/hyperledger/org1/peer1/assets/
cp /tmp/hyperledger/org0/orderer/channel.tx /tmp/hyperledger/org2/peer1/assets/
sudo docker exec cli-org1 sh -c "export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/admin/msp;peer channel create -c mychannel -f /tmp/hyperledger/org1/peer1/assets/channel.tx -o orderer1-org0:7050 --outputBlock /tmp/hyperledger/org1/peer1/assets/mychannel.block --tls --cafile /tmp/hyperledger/org1/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem"



echo "#####################################"
echo " "
echo "Trnasfer mychannel.block out of band"
echo " "
echo "#####################################"
cp /tmp/hyperledger/org1/peer1/assets/mychannel.block /tmp/hyperledger/org1/peer2/assets/
cp /tmp/hyperledger/org1/peer1/assets/mychannel.block /tmp/hyperledger/org2/peer1/assets/
cp /tmp/hyperledger/org1/peer1/assets/mychannel.block /tmp/hyperledger/org2/peer2/assets/


echo "#####################################"
echo " "
echo "Org1's Peer1,2 Join in channel"
echo " "
echo "#####################################"
sudo docker exec cli-org1 sh -c "export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/admin/msp;export CORE_PEER_ADDRESS=peer1-org1:7051;peer channel join -b /tmp/hyperledger/org1/peer1/assets/mychannel.block;export CORE_PEER_ADDRESS=peer2-org1:7051;peer channel join -b /tmp/hyperledger/org1/peer1/assets/mychannel.block"

echo " "
echo "#####################################"
echo " "
echo "Org2's Peer1,2 Join in channel"
echo " "
echo "#####################################"
echo " "

sudo docker exec cli-org2 sh -c "export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org2/admin/msp;export CORE_PEER_ADDRESS=peer1-org2:7051;peer channel join -b /tmp/hyperledger/org2/peer1/assets/mychannel.block;export CORE_PEER_ADDRESS=peer2-org2:7051;peer channel join -b /tmp/hyperledger/org2/peer1/assets/mychannel.block"


echo " "
echo "#####################################"
echo " "
echo "Install and Instantiate Chaincode"
echo " "
echo "#####################################"
echo " "

# transfer the chaincode
cd /tmp/
sudo chown -R lab:lab *
cd $HOME/guide
cp -R  $HOME/guide/chaincode /tmp/hyperledger/org1/peer1/assets/


# Org1's Peer1,2 chaincode install
echo " "
echo "########################## "
echo " "
echo "org1 chaincode install"
echo " "
echo "########################## "
echo " "


sudo docker exec cli-org1 sh -c "export CORE_PEER_ADDRESS=peer1-org1:7051;export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/admin/msp;peer chaincode install -n mycc -v 1.0 -l node  -p /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/voting/javascript;echo \"###peer2###\";export CORE_PEER_ADDRESS=peer2-org1:7051;export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/admin/msp;peer chaincode install -n mycc -v 1.0 -l node -p /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/voting/javascript"



# Org2's Peer1,2 chaincode install
echo " "
echo "########################################## "
echo " "
echo "org2 chaincode install and instantiate"
echo " "
echo "########################################## "
echo " "


sudo docker exec cli-org2 sh -c "export CORE_PEER_ADDRESS=peer1-org2:7051;export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org2/admin/msp;peer chaincode install -n mycc -v 1.0 -l node -p /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/voting/javascript;export CORE_PEER_ADDRESS=peer2-org2:7051;export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org2/admin/msp;peer chaincode install -n mycc -v 1.0 -l node -p /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/voting/javascript;peer chaincode instantiate -C mychannel -n mycc -v 1.0 -l node -c '{\"Args\":[\"initLedger\"]}' -o orderer1-org0:7050 --tls --cafile /tmp/hyperledger/org2/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem"


sleep 10
#echo " "
#echo "#####################################"
#echo " "
#echo "Test Chaincode (Query, Invoke)"
#echo " "
#echo "#####################################"
#echo " "
#
## Query Test From Org1's CLI
## If it is successful, it will return 100
#echo " "
#echo "Query test From Org1's CLI"
#echo " "
#sudo docker exec cli-org1 sh -c "export CORE_PEER_ADDRESS=peer1-org1:7051;export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/admin/msp;peer chaincode query -C mychannel -n mycc -c '{\"Args\":[\"queryCurrentSituation\"]}'"
#
#
## Query Test From Org2's CLI
#echo " "
#echo "Query test From Org2's CLI"
#echo " "
#
## Invoke 
#echo " "
#echo "Invoke"
#echo " "
#sudo docker exec cli-org2 sh -c "export CORE_PEER_ADDRESS=peer1-org2:7051;export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org2/admin/msp;peer chaincode invoke -C mychannel -n mycc -c '{\"Args\":[\"createVote\",\"12345689\",\"Hong\",1,\"PWG\",\"AISL\"]}' --tls --cafile /tmp/hyperledger/org2/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem"
#sleep 3
#
## Query
## If it is successful, it will return 90
#echo " "
#echo "Query"
#echo " "
#sudo docker exec cli-org2 sh -c "export CORE_PEER_ADDRESS=peer1-org2:7051;export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org2/admin/msp;peer chaincode query -C mychannel -n mycc -c '{\"Args\":[\"queryCurrentSituation\"]}'"
