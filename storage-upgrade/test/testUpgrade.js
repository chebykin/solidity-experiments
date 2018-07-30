const RichStorage_V1 = artifacts.require('./RichStorage_V1.sol');
const RichStorage_V2 = artifacts.require('./RichStorage_V2.sol');
const UpgradeabilityProxy = artifacts.require('./UpgradeabilityProxy.sol');
const Web3 = require('web3');
const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');

const { expect } = chai;

chai.use(chaiAsPromised);

let sleep = async function(timeout) {
    return new Promise(resolve => {
        setTimeout(resolve, timeout);
    });
};

contract('RichStorage', ([_, deployer]) => {
    const web3 = new Web3(RichStorage_V1.web3.currentProvider);

    describe('upgrade', () => {
        it('should provide variables information', async function () {
            const proxyTruffle = await UpgradeabilityProxy.new({ from: deployer });
            const richStorageTruffle = await RichStorage_V1.new({ gas: 500000 });
            const proxy = new web3.eth.Contract(proxyTruffle.abi, proxyTruffle.address, {from: deployer});

            proxy.methods.upgrade(richStorageTruffle.address).send();
            await sleep(500);
            const rs1Truffle = await RichStorage_V1.at(proxyTruffle.address);
            const rs1 = await new web3.eth.Contract(rs1Truffle.abi, rs1Truffle.address, {from: deployer});
            res = await rs1.methods.initialize().send();

            const richStorageTruffle_v2 = await RichStorage_V2.new({ gas: 500000 });
            proxy.methods.upgrade(richStorageTruffle_v2.address).send();

            await sleep(500);

            const rs2Truffle = await RichStorage_V2.at(proxyTruffle.address);
            const rs2 = await new web3.eth.Contract(rs2Truffle.abi, rs2Truffle.address, {from: deployer});

            res = await rs2.methods.resetUint().send();
            res = await rs2.methods.initialize().send();
            res = await rs2.methods.myUint().call();

            console.log("proxy", proxyTruffle.address);
            console.log("rs1", richStorageTruffle.address);
            console.log("rs2", richStorageTruffle_v2.address);

            for (let i = 0; i < 20; i++) {
                const rs2 = await web3.eth.getStorageAt(rs2Truffle.address, i);
                console.log(i, '>>>', rs2);
            }
            expect(2).to.be.eq(3);
        })
    });
});
