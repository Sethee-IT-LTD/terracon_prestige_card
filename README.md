# Integration of Starknet Contract with Web Application

## Introduction

This document details the integration process of the Starknet contract for the Terracon Prestige Card NFT minting system with a web application. The contract is developed in Cairo, leveraging OpenZeppelin library components for robust functionality.

## Current Contract Functionality

- Implements the ERC721 token standard for NFTs.
- Incorporates ERC721 metadata, SRC5, and ownership management.
- Maintains a storage struct with information on public sale status, whitelist Merkle root, next token ID, and whitelisted addresses.
- The constructor initializes the contract with a name, symbol, and an owner, minting initial tokens.
- Allows users to mint NFTs, considering whitelist status and public sale availability.
- Provides functionality for the owner to toggle public sale status.
- Permits the contract owner to whitelist addresses.

## Required Changes for Web Application Integration

### 1. `totalSupply` Function

- Implement `total_supply` to return the total tokens minted.
- Calculate this value using `next_token_id - 1`.

### 2. `tokenURI` Function

- Introduce `token_uri`, accepting a `token_id` to return its URI.
- Utilize `_set_token_uri` to fetch the token URI.

### 3. `balanceOf` Function

- Make `balance_of` externally accessible with `#[abi(embed_v0)]` in `ERC721Impl`.

### 4. `tokenOfOwnerByIndex` Function

- Add `token_of_owner_by_index` for fetching a token ID by owner address and index.
- Update a mapping of owner-to-token IDs upon minting or transfer.

### 5. `name` and `symbol` Functions

- Create functions `name` and `symbol` to return the token's name and symbol respectively.

### 6. Metadata Storage

- Consider on-chain metadata storage over IPFS.
- Define a `TokenMetadata` struct with `name`, `description`, `image`, `external_url`, and `attributes`.
- Adapt `_mint` to store metadata in a mapping linked to the token ID.
- Modify `token_uri` to return on-chain metadata.

### 7. Events

- Emit events for actions like minting, public sale status changes, and address whitelisting.
- Use event structs and `emit` for notifications.

## Plan for Storing Metadata On-Chain

1. **TokenMetadata Struct**: Include fields for comprehensive token information.
2. **Storage Mapping**: Map `token_metadata` to token IDs and their `TokenMetadata`.
3. **Minting Modification**: Adjust `_mint` to include metadata storage.
4. **Token URI Update**: Change `token_uri` to provide metadata as a JSON string.
5. **Web Application Adjustments**: Ensure metadata provision during minting.

By adhering to these recommendations, the Starknet contract will seamlessly integrate with the web application, enhancing functionalities like total supply visibility and metadata retrieval.
