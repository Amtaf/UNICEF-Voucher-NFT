
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./libraries/Base64.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract Voucher is ERC721{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct VoucherAttributes {
    uint voucherIndex;
    string name;
    string imageURI;        
    uint vp;
    uint maxvp;
    uint voucherDamage;
  }
  // array to help us hold the default data for our vouchers
  VoucherAttributes[] defaultVouchers;

  // mapping from the nft's tokenId to NFT(voucher) attributes.
  mapping(uint256 => VoucherAttributes) public nftHolderAttributes;

  // store owner of nft.
  mapping(address => uint256) public nftHolders;

  event VoucherNFTMinted(address sender, uint256 tokenId, uint256 voucherIndex);

  constructor(
    string[] memory voucherNames,
    string[] memory voucherImageURIs,
    uint[] memory vouchervp,
    uint[] memory voucherUsageDmg
  ) 
  ERC721("Unicef Voucher Tokens", "UVT")
  {
      for(uint i = 0; i < voucherNames.length; i += 1) {
      defaultVouchers.push(VoucherAttributes({
        voucherIndex: i,
        name: voucherNames[i],
        imageURI: voucherImageURIs[i],
        vp: vouchervp[i],
        maxvp: vouchervp[i],
        voucherDamage: voucherUsageDmg[i]
     }));

      VoucherAttributes memory v = defaultVouchers[i];
      console.log("Done initializing %s w/ VP %s, img %s", v.name, v.vp, v.imageURI);
      
    }
       _tokenIds.increment();
  }
  function mintVoucherNFT(uint _voucherIndex) external {
      uint256 newItemId = _tokenIds.current();
      _safeMint(msg.sender, newItemId);
       nftHolderAttributes[newItemId] = VoucherAttributes({
      voucherIndex: _voucherIndex,
      name:defaultVouchers[_voucherIndex].name,
      imageURI: defaultVouchers[_voucherIndex].imageURI,
      vp: defaultVouchers[_voucherIndex].vp,
      maxvp: defaultVouchers[_voucherIndex].maxvp,
      voucherDamage: defaultVouchers[_voucherIndex].voucherDamage
    });

    emit VoucherNFTMinted(msg.sender, newItemId, _voucherIndex);

    console.log("Minted NFT w/ tokenId %s and voucher rIndex %s", newItemId, _voucherIndex);

//nft(voucher) owner
    nftHolders[msg.sender] = newItemId;

    //increment next person token  
    _tokenIds.increment();
  }

  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
  VoucherAttributes memory vouAttributes = nftHolderAttributes[_tokenId];

  string memory strvp = Strings.toString(vouAttributes.vp);
  string memory strMaxvp = Strings.toString(vouAttributes.maxvp);
  string memory strvoucherDamage = Strings.toString(vouAttributes.voucherDamage);

  string memory json = Base64.encode(
    abi.encodePacked(
      '{"name": "',
      vouAttributes.name,
      ' -- NFT #: ',
      Strings.toString(_tokenId),
      '", "description": "This is an NFT that lets people mint relief vouchers sponsored by unicef!", "image": "',
      vouAttributes.imageURI,
      '", "attributes": [ { "trait_type": "VOUCHER Points", "value": ',strvp,', "max_value":',strMaxvp,'}, { "trait_type": "Voucher Depletion", "value": ',
      strvoucherDamage,'} ]}'
    )
  );

  string memory output = string(
    abi.encodePacked("data:application/json;base64,", json)
  );
  
  return output;
}
function checkIfUserHasNFT() public view returns (VoucherAttributes memory) {
 
  uint256 userNftTokenId = nftHolders[msg.sender];
  
  if (userNftTokenId > 0) {
    return nftHolderAttributes[userNftTokenId];
  }
  // return an empty character.
  else {
    VoucherAttributes memory emptyStruct;
    return emptyStruct;
   }
}
function getAllDefaultVouchers() public view returns (VoucherAttributes[] memory) {
  return defaultVouchers;
}
}