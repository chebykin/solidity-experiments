const Geohashes = artifacts.require('./Geohashes.sol');
const Web3 = require('web3');
const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');
const BN = Web3.utils.BN;

const { expect } = chai;

chai.use(chaiAsPromised);

contract('Geohashes', ([deployer]) => {
    const web3 = new Web3(Geohashes.web3.currentProvider);

    before(async function() {
        this.geohashesTruffle = await Geohashes.new();
        this.geohashes = new web3.eth.Contract(this.geohashesTruffle.abi, this.geohashesTruffle.address, { from: deployer });
    });

    describe('setters', () => {
        it('should set string variable', async function () {
            let tx = await this.geohashes.methods.setString("seze792kh375").send();
            let st = await web3.eth.getStorageAt(this.geohashesTruffle.address, 0);
            console.log("string\nstorage slot:", st, "\n", "gas:", tx.gasUsed, "\n\n-----------------\n");
        })

        it('should set bytesString variable', async function () {
            let tx = await this.geohashes.methods.setBytesStr(
                web3.utils.toHex("seze792kh375")).send();
            let st = await web3.eth.getStorageAt(this.geohashesTruffle.address, 2);
            console.log("bytesString\nstorage slot:", st, "\n", "gas:", tx.gasUsed, "\n\n-----------------\n");
        })

        it('should set bytesInt variable', async function () {
            let tx = await this.geohashes.methods.setBytesInt(
                new BN('440216548224273637')).send();
            console.log("bytesInt >>>", tx.gasUsed);
            let st = await web3.eth.getStorageAt(this.geohashesTruffle.address, 1);
            console.log("bytesInt\nstorage slot:", st, "\n", "gas:", tx.gasUsed, "\n\n-----------------\n");
        })

        it('should set int variable', async function () {
            let tx = await this.geohashes.methods.setInt(
                new BN('440216548224273637')).send();
            let st = await web3.eth.getStorageAt(this.geohashesTruffle.address, 3);
            console.log("int\nstorage slot:", st, "\n", "gas:", tx.gasUsed, "\n\n-----------------\n");
        })
    });

    describe.only('setters', () => {
        it('should encode string geohash to numeric using in-storage map', async function() {
            const val = web3.utils.asciiToHex("seze792kh375");
            let tx = await this.geohashes.methods.convertMap(val).send({ gas: 500000 });
            console.log("Gas consumed storage:", tx.gasUsed);
            let res = await this.geohashes.methods.converted().call();
            assert.equal(res.toString(10), '880433086698360037');
        })

        it('should encode string geohash to numeric using memory-only conversion', async function() {
            const val = web3.utils.asciiToHex("seze792kh375");
            let tx = await this.geohashes.methods.convert(val).send({ gas: 500000 });
            console.log("Gas consumed memory:", tx.gasUsed);
            let res = await this.geohashes.methods.converted().call();
            assert.equal(res.toString(10), '880433086698360037');
        })
    })
});
