const RichStorage = artifacts.require('./RichStorage.sol');
const Web3 = require('web3');
const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');

const { expect } = chai;

chai.use(chaiAsPromised);

contract('RichStorage', accounts => {
    const web3 = new Web3(RichStorage.web3.currentProvider);

    describe('access', () => {
        it('should provide variables information', async function () {
            const richStorage = await RichStorage.new();

            console.log(await web3.eth.getStorageAt(richStorage.address, 0));
            console.log(await web3.eth.getStorageAt(richStorage.address, 1));
            console.log(await web3.eth.getStorageAt(richStorage.address, 2));
            console.log(await web3.eth.getStorageAt(richStorage.address, 3));
            console.log(await web3.eth.getStorageAt(richStorage.address, 4));
        })
    });
});
