import { ethers, upgrades } from "hardhat";

const EP_ADDR = process.env.EP_ADDR;
async function main() {
  const [owner] = await ethers.getSigners();
  console.log(owner.address);
  const Account = await ethers.getContractFactory("Account");
  console.log("Deploying Account...");
  const account = await upgrades.deployProxy(
    Account,
    [owner.address, EP_ADDR],
    {
      initializer: "initialize",
      initialOwner: owner.address,
    }
  );
  await account.waitForDeployment();
  const accountAddr = await account.getAddress();
  console.log("Account deployed to:", accountAddr);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
