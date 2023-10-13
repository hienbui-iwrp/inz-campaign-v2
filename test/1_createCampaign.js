const fs = require("fs");
const { BigNumber } = require("@ethersproject/bignumber");
var CampaignNFT721 = artifacts.require("CampaignNFT721");
var CampaignFactory = artifacts.require("CampaignFactory");

function wf(name, address) {
  fs.appendFileSync(".env", name + "=" + address);
  fs.appendFileSync(".env", "\r\n");
}
/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
require("dotenv").config();

contract("CampaignFactory", async function (accounts) {
  it("Create campaign", async function () {
    const campaignFactory = await CampaignFactory.at(
      process.env.CampaignFactory
    );

    const campaignNFT721 = await CampaignNFT721.at(process.env.CampaignNFT721);

    const uri = "/nft721";
    const nullAddress = "0x0000000000000000000000000000000000000000";
    const name = "NFT721";
    const symbol = "N7";
    const supply = 100;
    const startTime = 0;
    const endTime = BigNumber.from("1000000000000000000");
    const price = BigNumber.from("0");
    const feeAddress = process.env.RECEIVER;

    const createCamapaignLog = await campaignFactory.createCampaign721(
      uri,
      nullAddress,
      name,
      symbol,
      startTime,
      endTime.toBigInt(),
      price.toBigInt(),
      supply,
      feeAddress
    );

    console.log("createCamapaignLog: ", createCamapaignLog);

    for (let i = 0; i < createCamapaignLog.logs.length; i++) {
      console.log("createCamapaignLog arg: ", createCamapaignLog.logs[i].args);
    }

    const cloneCampaign =
      createCamapaignLog.logs[createCamapaignLog.logs.length - 1].args[0];
    console.log("clone address: ", cloneCampaign);

    // new clone box campaign
    wf("CampaignNFT721Clone", cloneCampaign);

    return assert.isTrue(true);
  });
});
