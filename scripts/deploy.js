const main = async () => {
    const VoucherFactory = await hre.ethers.getContractFactory('Voucher');
    const VoucherContract = await VoucherFactory.deploy(
        ["Food", "Shelter", "Clothing","Education"],       // Names
        ["https://pbs.twimg.com/media/EQq6YMkW4AEuST0.jpg", // Images
        "http://reiwealthmag.com/wp-content/uploads/2019/11/Housing-Choice-Voucher-Program.jpg",
        "https://previews.123rf.com/images/hatza/hatza1308/hatza130800410/21393984-cartoon-female-clothing.jpg", 
        "https://i.imgur.com/WMB6g9u.https://previews.123rf.com/images/irwanjos/irwanjos1506/irwanjos150600061/41721908-school-building-cartoon.jpg"],
        [100, 200, 300,400],                    // HP values
        [100, 50, 25,40]   
    );
    await VoucherContract.deployed();
    console.log("Contract deployed to:", VoucherContract.address);
    let txn;
// we mint voucher at index 3
txn = await VoucherContract.mintVoucherNFT(1);
await txn.wait();
console.log("Minted 2nd NFT");
txn = await VoucherContract.mintVoucherNFT(2);
await txn.wait();
console.log("Minted 3rd NFT");
txn = await VoucherContract.mintVoucherNFT(3);
await txn.wait();
console.log("Minted 4th NFT");
console.log("finishde minting!");

// value of the NFT's URI.
//let returnedTokenUri = await VoucherContract.tokenURI(1);
//console.log("Token URI:", returnedTokenUri);

  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();