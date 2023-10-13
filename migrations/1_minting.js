const console = require("console");
const fs = require("fs");

// command line run: truffle migrate --f 1 --to 1 --network base_goerli -reset --compile-none

var CampaignNFT721 = artifacts.require("CampaignNFT721");
var CampaignFactory = artifacts.require("CampaignFactory");

function wf(name, address) {
  fs.appendFileSync(".env", name + "=" + address);
  fs.appendFileSync(".env", "\r\n");
}

const deployments = {
  campaignNFT721: true,
  campaignFactory: true,
};

module.exports = async function (deployer, network, accounts) {
  let account = deployer.options?.from || accounts[0];
  console.log("deployer = ", account);
  require("dotenv").config();

  if (deployments.campaignNFT721) {
    await deployer.deploy(CampaignNFT721);

    var _campaignNFT721 = await CampaignNFT721.deployed();

    wf("CampaignNFT721", _campaignNFT721.address);
  } else {
    var _campaignNFT721 = await CampaignNFT721.at(process.env.CampaignNFT721);
  }

  if (deployments.campaignFactory) {
    await deployer.deploy(CampaignFactory, _campaignNFT721.address);

    var _campaignFactory = await CampaignFactory.deployed();

    wf("CampaignFactory", _campaignFactory.address);
  } else {
    var _campaignFactory = await CampaignFactory.at(
      process.env.CampaignFactory
    );
  }
};
