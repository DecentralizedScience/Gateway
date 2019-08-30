
# Gateway Server for Decentralized Science
Gateway test server for [Decentralized Science](decentralized.science)

This gateway server acts as a bridge between IPFS and Ethereum to run Decentralized Science.

## Installation

If you want to run the platform locally, first you need to be able to connect to Ethereum and IPFS in the same machine. To do so, you must have the following dependencies:

### 1. IPFS

First the gateway server needs access to IPFS and run its daemon.

You can download the last version of IPFS in ```https://docs.ipfs.io/introduction/install/```

After the installation, start IPFS with the following steps via console commands:

Initialize IPFS local repository
```bash
ipfs init
```

Launch IPFS daemon
```bash
ipfs daemon
```

### 2. Metamask or an Ethereum web browser

In order to be able to make transactions to the platform, the web browser must be connected to Ethereum.

You can install Metamask extension ```https://metamask.io/``` or a web browser like Brave ```https://brave.com/``` or Mist ```https://github.com/ethereum/mist```.


### 3. Launch Python simple HTTP server

In order to run the IPFS gateway, you must launch a local server in your machine.

```bash
python3 server.py
```

### 4. Deploy the smart contracts in Ethereum

To test this project, install ganache client:

``` bash
npm install -g ganache-cli
```

and launch it

``` bash
ganache-cli
```

Then you can visit the home page of the prototype at http://localhost:8081

There, you can deploy the reputation hub.

Then you can create a journal and get the Ethereum address.

The platform now can be accessed via ```http://127.0.0.1/jourmal?q=<paste_address_here>```

### 5. Launch a test Ethreum network with Ganache-cli (optional).

If you want to run the platform in a local test network instead of the ones provided by Ethereum you must install ```ganache-cli```. Make sure you have Node.js (>= v6.11.5) installed.

```
npm install -g ganache-cli
```
Once installed get your Ethereum's account private key through Metamask options. Then launch ganache-cli with the command:

```
ganache-cli --account="0x<your-private-key>,100000000000000000000"
```
___
## Files

 ```contracts``` contains the smart contacts file. In order to run the platform, the contract must be deployed in Ethereum.

 ```abi``` contains the contrat ABI's to connect JavaScript with Ethereum.

```js``` contains JavaScript files.

```testjson``` contains some JSON files to test the platform's behaviour.

 ```css``` contains some style files.
