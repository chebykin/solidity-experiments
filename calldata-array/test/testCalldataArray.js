const CalldataArray = artifacts.require('./CalldataArray.sol');
const Web3 = require('web3');
const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');

const { expect } = chai;

chai.use(chaiAsPromised);

contract('CalldataArray', accounts => {
    const web3 = new Web3(CalldataArray.web3.currentProvider);

    describe('call', () => {
        it('should provide an option to accept 256-items array', async function () {
            const len = 256;
            let ary2pass = [];

            for (let i = 0; i < len; i++) {
                ary2pass.push(i * 1e9);
            }

            const cAry = await CalldataArray.new();
            let res = await cAry.acceptArray(ary2pass);
            console.log(res.logs[0].args.length.toString());
            res = await cAry.empty();
        })
    });
});
