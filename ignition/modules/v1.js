const { ethers, upgrades } = require("hardhat");
const fs = require("fs");

async function main() {
  const CrowdfundingPlatform = await ethers.getContractFactory("CrowdfundingPlatform");

  const initialOwner = "0xf8e81D47203A594245E36C48e151709F0C19fBe8";
  const platform = await upgrades.deployProxy(CrowdfundingPlatform, [initialOwner], { initializer: "initialize" });

  await platform.waitForDeployment();
  const proxyAddress = platform.target;
  console.log("CrowdfundingPlatform deployed to:", platform.target);

  fs.writeFileSync("proxyAddress.txt", proxyAddress);
}

main();