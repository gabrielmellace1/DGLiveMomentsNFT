const { ethers } = require("hardhat");
const hre = require("hardhat");


// npx hardhat run --network polygon scripts/deployDGLiveMoments.js
// npx hardhat verify --network polygon 0x7fA703Af90E17672B9e3449582b2353fbDAa10E3 "DG Live Moments" "DG Live Moments"

async function main() {
  // Compile the contracts
  await hre.run("compile");

  // Deploy the contract
  const DGLiveMoments = await ethers.getContractFactory("DGLiveMoments");
  const name = "DG Live Moments";
  const symbol = "DG Live Moments";


  const dglivemomentsnft = await DGLiveMoments.deploy(name, symbol);

  await dglivemomentsnft.deployed();
  console.log("DG Live Moments deployed to:", dglivemomentsnft.address);


  const uri = "https://ipfs.io/ipfs/QmZu1E9xnLPLz7K3WaHQpDTLwt7avTkmtE8SjyYHFpDtRm";



  await dglivemomentsnft.safeMint(uri);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
