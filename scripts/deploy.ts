import { ethers, upgrades, network } from "hardhat";

async function main() {
  const [owner] = await ethers.getSigners();

  const entryPoint = await ethers.deployContract("EntryPoint");
  await entryPoint.waitForDeployment();
  const epAddress = await entryPoint.getAddress();
  console.log("EntryPoint deployed to:", epAddress);


  const Account = await ethers.getContractFactory("Account");
  console.log("Deploying Account...");
  const account = await upgrades.deployProxy(
    Account,
    [owner.address, epAddress],
    {
      initializer: "initialize",
      initialOwner: owner.address,
    }
  );
  await account.waitForDeployment();
  const accountAddr = await account.getAddress();
  console.log("Account deployed to:", accountAddr);


  const Gateway = await ethers.getContractFactory("Gateway");
  console.log("Deploying Gateway...");
  const gateway = await upgrades.deployProxy(
    Gateway,
    [owner.address],
    {
      initializer: "init_gateway",
      initialOwner: owner.address,
    }
  );
  await gateway.waitForDeployment();
  const gatewayAddr = await gateway.getAddress();
  console.log("Gateway deployed to:", gatewayAddr);


  const BillPoint = await ethers.getContractFactory("BillPoint");
  console.log("Deploying BillPoint...");
  const billPoint = await upgrades.deployProxy(
    BillPoint,
    [owner.address, gatewayAddr, "https://www.dexafi.xyz"],
    {
      initializer: "init_bill_point",
      initialOwner: owner.address,
    }
  );
  await billPoint.waitForDeployment();
  const billPointAddr = await billPoint.getAddress();
  console.log("BillPoint deployed to:", billPointAddr);

  
  await gateway.init_roles(billPointAddr);
  await billPoint.init_roles(gatewayAddr);
  await gateway.batchEnlistTokens([
    "0xBf3edC332bd9E1C32D10d2511B61938D1A6b4D01",
    "0xE8a8f500301c778064E380E5bFA9E315a7638134",
  ]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
