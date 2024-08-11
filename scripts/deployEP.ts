import { ethers } from "hardhat";

async function main() {
  const entryPoint = await ethers.deployContract("EntryPoint");
  await entryPoint.waitForDeployment();
  const epAddress = await entryPoint.getAddress();
  console.log("EntryPoint deployed to:", epAddress);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
