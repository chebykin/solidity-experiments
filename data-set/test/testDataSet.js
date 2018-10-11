const DataSet = artifacts.require('./DataSet.sol');
const Web3 = require('web3');
const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');
const BN = Web3.utils.BN;

const { expect } = chai;

chai.use(chaiAsPromised);

contract('DataSet', ([deployer]) => {
    const web3 = new Web3(DataSet.web3.currentProvider);

    beforeEach(async function() {
        this.dataSet = await DataSet.new();
        this.items = ['item1', 'item2', 'item3'];
        this.item1 = web3.utils.stringToHex('item1');
        this.item2 = web3.utils.stringToHex('item2');
        this.item3 = web3.utils.stringToHex('item3');
        this.nonExistent = web3.utils.stringToHex('non-existent');
    });

    describe('with no elements', () => {
        it('should return 0 length', async function () {
            let len = await this.dataSet.length();
            assert.equal(len, 0);
        });

        it('should reject on a random remove request', async function () {
            await assertRevert(this.dataSet.remove(this.item1));
        });
    });

    describe('with a single element', () => {
        it('should allow add/remove a single element', async function () {
            let len = await this.dataSet.length();
            assert.equal(len, 0);

            await this.dataSet.add(this.item1);
            await assertRevert(this.dataSet.add(this.item1));

            len = await this.dataSet.length();
            assert.equal(len, 1);

            await this.dataSet.remove(this.item1);
            await assertRevert(this.dataSet.remove(this.item1));

            len = await this.dataSet.length();
            assert.equal(len, 0);
        });

        it('should deny remove non existent element', async function () {
            let len = await this.dataSet.length();
            assert.equal(len, 0);

            await this.dataSet.add(this.item1);

            len = await this.dataSet.length();
            assert.equal(len, 1);

            await assertRevert(this.dataSet.remove(this.nonExistent));

            len = await this.dataSet.length();
            assert.equal(len, 1);
        });
    });

    describe('with multiple elements', () => {
        it('should allow add/remove elements', async function () {
            let len = await this.dataSet.length();
            assert.equal(len, 0);
            let elements = await this.dataSet.elements();
            assert.sameMembers(elements, []);

            let {item1, item2, item3} = this;

            await this.dataSet.add(this.item1);
            await this.dataSet.add(this.item2);
            await this.dataSet.add(this.item3);
            await assertRevert(this.dataSet.add(this.item1));
            await assertRevert(this.dataSet.add(this.item2));
            await assertRevert(this.dataSet.add(this.item3));

            len = await this.dataSet.length();
            assert.equal(len, 3);

            elements = await this.dataSet.elements();
            assert.sameMembers(elements.map(web3.utils.hexToString), this.items);

            // remove 1st
            await this.dataSet.remove(item1);

            len = await this.dataSet.length();
            assert.equal(len, 2);

            elements = await this.dataSet.elements();
            assert.sameMembers(elements.map(web3.utils.hexToString), [item2, item3].map(web3.utils.hexToString));

            // remove last
            await this.dataSet.remove(item3);

            len = await this.dataSet.length();
            assert.equal(len, 1);

            elements = await this.dataSet.elements();
            assert.sameMembers(elements.map(web3.utils.hexToString), [item2].map(web3.utils.hexToString));

            // add one again
            await this.dataSet.add(this.item1);

            len = await this.dataSet.length();
            assert.equal(len, 2);

            elements = await this.dataSet.elements();
            assert.sameMembers(elements.map(web3.utils.hexToString), [item2, item1].map(web3.utils.hexToString));
        });
    })
});

async function assertRevert(promise) {
    try {
        await promise;
    } catch (error) {
        const revert = error.message.search('revert') >= 0;
        assert(revert, `Expected throw, got '${error}' instead`);
        return;
    }
    assert.fail('Expected throw not received');
}
