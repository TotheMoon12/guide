'use strict';

const { FileSystemWallet, Gateway, X509WalletMixin } = require('fabric-network');
const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml')

// capture network variables from config.json
const configPath = path.join(process.cwd(), '/config.json');
const configJSON = fs.readFileSync(configPath, 'utf8');
const config = JSON.parse(configJSON);
var connection_file = config.connection_file;
var userName = config.userName;
var gatewayDiscovery = config.gatewayDiscovery;

// connect to the connection file
const filePath = path.join(process.cwd(), '/connection.yaml');
let fileContents = fs.readFileSync(filePath, 'utf8');
let connectionFile = yaml.safeLoad(fileContents);


exports.createNewVotingroom = async function(title, candidateList, endtime) {
    try {

        var response = {};

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), '/wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(userName);
        if (!userExists) {
            console.log('An identity for the user ' + userName + ' does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            response.error = 'An identity for the user ' + userName + ' does not exist in the wallet. Register ' + userName + ' first';
            return response;
        }

        // Create a new gateway for connecting to our peer node.
        console.log('we here in createNewVotingroom')

        const gateway = new Gateway();
        await gateway.connect(connectionFile, { wallet, identity: userName, discovery: gatewayDiscovery });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('voting');

        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')

        await contract.submitTransaction('createNewVotingroom',title, candidateList, endtime );
        console.log('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

        response.msg = 'createNewVotingroom Transaction has been submitted';
        return response;        

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response; 
    }
}

// create car transaction
exports.createVote = async function(id, Symbol, Name, Belong, code, title) {
    try {

        var response = {};

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), '/wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(userName);
        if (!userExists) {
            console.log('An identity for the user ' + userName + ' does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            response.error = 'An identity for the user ' + userName + ' does not exist in the wallet. Register ' + userName + ' first';
            return response;
        }

        // Create a new gateway for connecting to our peer node.
        console.log('we here in createCar')

        const gateway = new Gateway();
        await gateway.connect(connectionFile, { wallet, identity: userName, discovery: gatewayDiscovery });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('voting');

        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')

        await contract.submitTransaction('createVote', id, Symbol, Name, Belong, code, title);
        console.log('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

        response.msg = 'createCar Transaction has been submitted';
        return response;        

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response; 
    }
}

exports.queryProgressList = async function() {
    try {

        var response = {};

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), '/wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(userName);
        if (!userExists) {
            console.log('An identity for the user ' + userName + ' does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            response.error = 'An identity for the user ' + userName + ' does not exist in the wallet. Register ' + userName + ' first';
            return response;
        }

        // Create a new gateway for connecting to our peer node.
        console.log('we here in queryProgressList')

        const gateway = new Gateway();
        await gateway.connect(connectionFile, { wallet, identity: userName, discovery: gatewayDiscovery });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('voting');

        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')

        const result = await contract.submitTransaction('queryProgressList');
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);

        // Disconnect from the gateway.
        await gateway.disconnect();

        return result;        

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response; 
    }
}

exports.queryEndList = async function() {
    try {

        var response = {};

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), '/wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(userName);
        if (!userExists) {
            console.log('An identity for the user ' + userName + ' does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            response.error = 'An identity for the user ' + userName + ' does not exist in the wallet. Register ' + userName + ' first';
            return response;
        }

        // Create a new gateway for connecting to our peer node.
        console.log('we here in queryEndList')

        const gateway = new Gateway();
        await gateway.connect(connectionFile, { wallet, identity: userName, discovery: gatewayDiscovery });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('voting');

        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')

        const result = await contract.submitTransaction('queryEndList');
        console.log(`Transaction has been evaluated, result is: ${result}`);

        // Disconnect from the gateway.
        await gateway.disconnect();

        return result;        

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response; 
    }
}

exports.queryAllData = async function() {
    try {

        var response = {};

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), '/wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(userName);
        if (!userExists) {
            console.log('An identity for the user ' + userName + ' does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            response.error = 'An identity for the user ' + userName + ' does not exist in the wallet. Register ' + userName + ' first';
            return response;
        }

        // Create a new gateway for connecting to our peer node.
        console.log('we here in queryAllData')

        const gateway = new Gateway();
        await gateway.connect(connectionFile, { wallet, identity: userName, discovery: gatewayDiscovery });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('voting');

        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')

        const result = await contract.submitTransaction('queryAllData');
        console.log('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

        return result;        

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response; 
    }
}

// query all cars transaction
exports.queryAllCandidate = async function(title) {
    try {
        console.log('starting to queryAllCandidate')

        var response = {};

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), '/wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(userName);
        if (!userExists) {
            console.log('An identity for the user ' + userName + ' does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            response.error = 'An identity for the user ' + userName + ' does not exist in the wallet. Register ' + userName + ' first';
            return response;            
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();

        await gateway.connect(connectionFile, { wallet, identity: userName, discovery: gatewayDiscovery });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('voting');

        // Evaluate the specified transaction.
        // queryAllCars transaction - requires no arguments, ex: ('queryAllCars')
        const result = await contract.evaluateTransaction('queryAllCandidate',title);

        console.log(`queryAllCandidate Transaction has been evaluated, result is: ${result.toString()}`);

        return result;

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        response.error = error.message;
        return response;
    }
}

exports.queryCurrentSituation = async function(title) {
    try {
        console.log('starting to queryCurrentSituation')

        var response = {};

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), '/wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(userName);
        if (!userExists) {
            console.log('An identity for the user ' + userName + ' does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            response.error = 'An identity for the user ' + userName + ' does not exist in the wallet. Register ' + userName + ' first';
            return response;            
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();

        await gateway.connect(connectionFile, { wallet, identity: userName, discovery: gatewayDiscovery });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('voting');

        // Evaluate the specified transaction.
        // queryAllCars transaction - requires no arguments, ex: ('queryAllCars')
        const result = await contract.evaluateTransaction('queryCurrentSituation',title);

        console.log(`queryCurrentSituation Transaction has been evaluated, result is: ${result}`);

        return result;

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        response.error = error.message;
        return response;
    }
}

exports.registerUser = async function(name ,id, passwd, userSsn){
    try {
        var response = {};
        var result;

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), '/wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(userName);
        if (!userExists) {
            console.log('An identity for the user ' + userName + ' does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            response.error = 'An identity for the user ' + userName + ' does not exist in the wallet. Register ' + userName + ' first';
            return response;
        }

        // Create a new gateway for connecting to our peer node.
        console.log('we here in registerUser')

        const gateway = new Gateway();
        await gateway.connect(connectionFile, { wallet, identity: userName, discovery: gatewayDiscovery });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('voting');

        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')

        result = await contract.submitTransaction('registerUser', name, id, passwd, userSsn);
        console.log('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

        return result;        

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response; 
    }
}

exports.login = async function(id, passwd){
    try {
        var response = {};
        var result;

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), '/wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(userName);
        if (!userExists) {
            console.log('An identity for the user ' + userName + ' does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            response.error = 'An identity for the user ' + userName + ' does not exist in the wallet. Register ' + userName + ' first';
            return response;
        }

        // Create a new gateway for connecting to our peer node.
        console.log('we here in login')

        const gateway = new Gateway();
        await gateway.connect(connectionFile, { wallet, identity: userName, discovery: gatewayDiscovery });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('voting');

        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')

        result = await contract.submitTransaction('login', id, passwd);
        console.log('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

        return result;        

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response; 
    }
}


function pad(n, width) {
    n = n + '';
    return n.length >= width ? n : new Array(width - n.length + 1).join('0') + n;
}

function gettime(year, month, day, hour, minute, sec, index){
    let result;

    minute = minute + (index*5);

    if (minute > 59){
        hour = hour + parseInt(minute/60);
        minute = minute%60;
    }

    if(hour > 23) {
        day = day + parseInt(hour/24);
        hour = hour%24;
    }

    if(day > 30) {
        month = month + parseInt(day/30);
        day = day%30;
    }

    if(month > 12) {
        year = year + parseInt(month/12);
        month = month%12;
    }

    result = String(year) + pad(month,2) + pad(day,2) + pad(hour,2) + pad(minute,2)+ pad(sec,2);

    return result;

}

exports.makeTestData = async function() {
    try {

        let response = {};

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), '/wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(userName);
        if (!userExists) {
            console.log('An identity for the user ' + userName + ' does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            response.error = 'An identity for the user ' + userName + ' does not exist in the wallet. Register ' + userName + ' first';
            return response;
        }

        // Create a new gateway for connecting to our peer node.
        console.log('we here in createCar')

        const gateway = new Gateway();
        await gateway.connect(connectionFile, { wallet, identity: userName, discovery: gatewayDiscovery });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        // const contract = network.getContract('fabcar');
        const contract = network.getContract('energy');

        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')
        const energy = {
            SITE_ID : '0000000000',
            PCS_ID : '00000000000000000000',
            PCS_CAPA : '0000000000000000000000',
            PCS_OP_MODE : '0000000000000000000000',
            PCS_ACC_CHAR : '0000000000000000000000',
            PCS_INSTANCE : '0000000000000000000000',
            PCS_ACC_DISCHAR : '0000000000000000000000',
            BMS_CURR : '0000000000000000000000',
            BMS_VOLT : '0000000000000000000000',
            BMS_SOC : '0000000000000000000000',
            SYS_MODE : '0000000000000000000000',
            PEAK_OF_MONTH : '0000000000000000000000',
            PEAK_OF_DAY : '0000000000000000000000',
            PEAK_OF_MAX : '0000000000000000000000',
            TOTAL_ACT_POWER : '0000000000000000000000',
            BATT_CAPA : '0000000000000000000000',
            DC_CURR : '0000000000000000000000',
            ACC_ACT_POWER : '0000000000000000000000',
            CELL_LOW_VOLTAGE : '0000000000000000000000',
            SYS_SOH : '0000000000000000000000',
            DC_VOLT : '0000000000000000000000',
            CELL_LOW_TEMP : '0000000000000000000000',
            CELL_MAX_VOLTAGE : '0000000000000000000000',
            CHAR_LIMITE : '0000000000000000000000',
            DISCH_LIMITE : '0000000000000000000000',
            CELL_MAX_TEMP : '0000000000000000000000',
            PCS_RUN : '0000000000000000000000',
            PCS_FAULT : '0000000000000000000000',
            PCS_MCAC : '0000000000000000000000',
            PCS_WARN : '0000000000000000000000',
            PCS_MCDC : '0000000000000000000000',
            PCS_OVDC : '0000000000000000000000',
            PCS_OCACR : '0000000000000000000000',
            PCS_OCACS : '0000000000000000000000',
            PCS_OCDC : '0000000000000000000000',
            PCS_OCACT : '0000000000000000000000',
            PCS_OVAC : '0000000000000000000000',
            PCS_UVAC : '0000000000000000000000',
            PCS_FHAC : '0000000000000000000000',
            PCS_FLAC : '0000000000000000000000',
            PCS_UVDL : '0000000000000000000000',
            PCS_ES : '0000000000000000000000',
            PCS_OVLD : '0000000000000000000000',
            PCS_OPDR : '0000000000000000000000',
            BATT_FAULT : '0000000000000000000000',
            PCS_OCAC : '0000000000000000000000',
            BATT_OCBT : '0000000000000000000000',
            BATT_UVBT : '0000000000000000000000',
            BATT_OVBT : '0000000000000000000000',
            BATT_FUSE : '0000000000000000000000',
            BATT_OT : '0000000000000000000000',
            BATT_IMBALV : '0000000000000000000000',
            BATT_IMBALT : '0000000000000000000000',
        };
        let year = 2017;
        let month = 1;
        let day = 1;
        let hour = 0;
        let minute = 0;
        let second = 0;
        
        for(let i=0; i<100; i++){
            for(let j=0; j<400; j++){
                energy.SITE_ID = pad(j+1, 10);
                const key = energy.SITE_ID + gettime(year,month,day,hour,minute,second,i);
                if(i%10==0 && j==399) {
                    console.log('#################')
                    console.log(`${i} , ${j} `)
                    console.log('#################')
                }
                if(i == 99 && j == 399) {
                    await contract.submitTransaction('createData', key, JSON.stringify(energy));
                    console.log('#################')
                    console.log('마지막 Transaction has been submitted');
                    console.log('#################')
                }
                else {
                    // console.log('#################')
                    // console.log(`날리고 있슴다 ${i}`)
                    // console.log('#################')
                    if(i%10==0 && j==399) {
                        await contract.submitTransaction('test', key, JSON.stringify(energy));
                    }
                    else {
                        contract.submitTransaction('createData', key, JSON.stringify(energy));
                    }
                    
                }
                
            }
        }
        
        // Disconnect from the gateway.
        await gateway.disconnect();
        response.msg = 'createCar Transaction has been submitted';
        return response;        

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response; 
    }
}