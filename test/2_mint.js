const fs = require("fs");
const { BigNumber } = require("@ethersproject/bignumber");
var CampaignNFT721 = artifacts.require("CampaignNFT721");
var CampaignFactory = artifacts.require("CampaignFactory");

function wf(name, address) {
  fs.appendFileSync(".env", name + "=" + address);
  fs.appendFileSync(".env", "\r\n");
}
require("dotenv").config();
/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("CampaignNFT721", function (/* accounts */) {
  it("minting", async function () {
    const campaignFactory = await CampaignFactory.at(
      process.env.CampaignFactory
    );

    const campaignNFT721 = await CampaignNFT721.at(
      process.env.CampaignNFT721Clone
    );

    const platformFee = 0;
    const amount = 1;
    const discount = 0;

    const mintLog = await campaignNFT721.makeMintAction(
      platformFee,
      amount,
      discount
    );

    console.log("mintLog: ", mintLog);

    for (let i = 0; i < mintLog.logs.length; i++) {
      console.log("mintLog arg: ", mintLog.logs[i].args);
    }

    return assert.isTrue(true);
  });
});
