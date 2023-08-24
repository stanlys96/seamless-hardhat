// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.

const {
  networkConfig,
  developmentChains,
  VERIFICATION_BLOCK_CONFIRMATIONS,
} = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");
require("dotenv").config();
const { ethers } = require("hardhat");

async function main() {
  const seamless = await ethers.deployContract("Seamless", [
    process.env.VAULT_ADDRESS,
  ]);

  const tx = await seamless.waitForDeployment();
  console.log(tx, "<<< SEAMLESS");
  if (
    !developmentChains.includes(network.name) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    setTimeout(async () => {
      await verify(tx.target, []);
    }, 3500);
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
