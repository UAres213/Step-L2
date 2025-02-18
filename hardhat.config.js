require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-foundry");
require('@openzeppelin/hardhat-upgrades');
require("dotenv").config(); 
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = { 
  solidity: "0.8.24", 
  networks: { 
    hardhat: {}, 
    sepolia: { 
      url:
        "https://eth-sepolia.g.alchemy.com/v2/" + process.env.ALCHEMY_API_KEY, accounts: [`0x${process.env.PRIVATE_KEY}`], 
    }, 
  }, 
 };