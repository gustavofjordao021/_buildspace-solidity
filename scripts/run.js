const main = async () => {
  const [owner, randomPerson] = await ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("1"),
  });
  await waveContract.deployed();
  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let waveTxn = await waveContract.wave("A wild message appears!");
  await waveTxn.wait();

  waveTxn = await waveContract.wave("Another wild message appears!");
  await waveTxn.wait();

  let allWaves = await waveContract.getAllWaves();

  let waveCount = await waveContract.getTotalWaves();

  console.log(
    "The total number of waves is " + waveCount + " and their details are: "
  );
  console.log(allWaves);

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
