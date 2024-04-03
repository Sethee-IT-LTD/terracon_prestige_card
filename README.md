Document: Integration of Starknet Contract with Web Application

Introduction:
This document outlines the current state of the Starknet contract for the Terracon Prestige Card NFT minting system and the necessary changes required to properly integrate the contract with the web application. The contract is written in Cairo and utilizes various components from the OpenZeppelin library.

Current Contract Functionality:
1. The contract implements the ERC721 token standard for non-fungible tokens (NFTs).
2. It includes components for ERC721 metadata, SRC5 (Starknet Request for Comments 5), and ownership management.
3. The contract has a storage struct that holds information such as the public sale status, whitelist Merkle root, next token ID, and whitelisted addresses.
4. The constructor function initializes the contract with a name, symbol, and owner. It also mints initial tokens for the contract owner.
5. The `mint` function allows users to mint NFTs based on certain conditions, such as whitelist status and public sale status.
6. The `set_public_sale_open` function allows the contract owner to open or close the public sale.
7. The `whitelist_addresses` function enables the contract owner to whitelist a list of addresses.

Required Changes for Web Application Integration:
To properly integrate the contract with the web application, the following changes and additions are necessary:

1. `totalSupply` function:
   - Add a new function called `total_supply` that returns the total number of tokens minted so far.
   - Implement this function by returning `next_token_id - 1`.

2. `tokenURI` function:
   - Add a new external function called `token_uri` that takes a `token_id` as input and returns the corresponding token URI.
   - Utilize the existing `_set_token_uri` function to retrieve the token URI.

3. `balanceOf` function:
   - Ensure that the `balance_of` function from the `ERC721Component` is accessible externally by adding the `#[abi(embed_v0)]` attribute to the `ERC721Impl` implementation.

4. `tokenOfOwnerByIndex` function:
   - Implement a new function called `token_of_owner_by_index` that takes an `owner` address and an `index` as input and returns the token ID owned by the `owner` at the given `index`.
   - Maintain a mapping of owner addresses to an array of their owned token IDs and update it whenever tokens are minted or transferred.

5. `name` and `symbol` functions:
   - Add new external functions called `name` and `symbol` that return the name and symbol of the token respectively.

6. Metadata Storage:
   - Consider storing the metadata directly on-chain instead of relying on IPFS URIs.
   - Create a `TokenMetadata` struct to represent the metadata for each token, including properties like `name`, `description`, `image`, `external_url`, and `attributes`.
   - Modify the `_mint` function to accept the metadata as input and store it in a mapping associated with the token ID.
   - Update the `token_uri` function to return the on-chain metadata instead of an IPFS URI.

7. Events:
   - Emit relevant events from the contract whenever significant actions occur, such as minting a token, setting the public sale status, or whitelisting addresses.
   - Define event structs for each event type and emit them using the `emit` function.

Plan for Storing Metadata On-Chain:
To store the metadata on-chain, follow these steps:

1. Define a `TokenMetadata` struct that includes fields for `name`, `description`, `image`, `external_url`, and `attributes`.
2. Create a storage mapping called `token_metadata` that maps token IDs to their corresponding `TokenMetadata`.
3. Modify the `_mint` function to accept the metadata as input and store it in the `token_metadata` mapping.
4. Update the `token_uri` function to retrieve the metadata from the `token_metadata` mapping and return it as a JSON string.
5. Adjust the web application to provide the necessary metadata during the minting process.

By implementing these changes, the Starknet contract will be properly integrated with the web application, enabling features such as displaying the total supply, retrieving token UR
