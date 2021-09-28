const main = async () => {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Token = await ethers.getContractFactory("WavePortal");
  const token = await Token.deploy({
    value: hre.ethers.utils.parseEther("0.001"),
  });

  console.log("WavePortal address:", token.address);
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
