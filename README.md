<h1>Integration of Starknet Contract with Web Application</h1>

<h2>Introduction</h2>
<p>This document elaborates on the process of integrating the Starknet contract for the Terracon Prestige Card NFT minting system with a web application. Crafted in Cairo, this contract harnesses the robust functionalities of the OpenZeppelin library.</p>

<h2>Current Contract Functionality</h2>
<ul>
  <li>Implements the ERC721 token standard for NFTs.</li>
  <li>Features ERC721 metadata, SRC5, and ownership management components.</li>
  <li>Contains a storage struct detailing public sale status, whitelist Merkle root, next token ID, and whitelisted addresses.</li>
  <li>The constructor sets up the contract with essential details and mints initial tokens for the owner.</li>
  <li>Facilitates NFT minting for users based on whitelist and public sale conditions.</li>
  <li>Includes functions for the contract owner to manage public sale and whitelist addresses.</li>
</ul>

<h2>Required Changes for Web Application Integration</h2>
<h3>1. <code>totalSupply</code> Function</h3>
<p>Introduce a <code>total_supply</code> function to track the total tokens minted. This is derived by subtracting one from the <code>next_token_id</code>.</p>

<h3>2. <code>tokenURI</code> Function</h3>
<p>Add a <code>token_uri</code> function to link a <code>token_id</code> to its corresponding URI, making use of the <code>_set_token_uri</code> for URI retrieval.</p>

<h3>3. <code>balanceOf</code> Function</h3>
<p>Ensure external accessibility of <code>balance_of</code> by applying <code>#[abi(embed_v0)]</code> in <code>ERC721Impl</code>.</p>

<h3>4. <code>tokenOfOwnerByIndex</code> Function</h3>
<p>Create a <code>token_of_owner_by_index</code> function for obtaining a token ID associated with an owner’s address and index.</p>

<h3>5. <code>name</code> and <code>symbol</code> Functions</h3>
<p>Develop functions to return the token’s name and symbol respectively.</p>

<h3>6. Metadata Storage</h3>
<p>Advocate for storing metadata on-chain as opposed to IPFS. Implement a <code>TokenMetadata</code> struct for detailed token info and modify the <code>_mint</code> function to include metadata input.</p>

<h3>7. Events</h3>
<p>Utilize events for significant contract activities, employing event structs and <code>emit</code> for communication.</p>

<h2>Plan for Storing Metadata On-Chain</h2>
<ol>
  <li><strong>TokenMetadata Struct:</strong> Incorporate fields for extensive token details.</li>
  <li><strong>Storage Mapping:</strong> Link <code>token_metadata</code> to token IDs for metadata access.</li>
  <li><strong>Minting Modification:</strong> Adapt <code>_mint</code> to store provided metadata.</li>
  <li><strong>Token URI Update:</strong> Revise <code>token_uri</code> to output metadata as a JSON string.</li>
  <li><strong>Web Application Adjustments:</strong> Prepare the application to supply metadata during minting.</li>
</ol>

<p>Adhering to this guide ensures the Starknet contract's seamless integration with web applications, promoting functionality like total supply visibility and metadata accessibility.</p>

<h2>In-depth Code Example for On-Chain Metadata Integration</h2>
<p>Below is a Cairo 2.0 syntax-highlighted snippet showcasing on-chain metadata integration:</p>

<pre>
<code>
#[starknet::contract]
mod NFTMint {
  ...

  #[storage]
  struct Storage {
    ...
    token_metadata: Mapping<u256, TokenMetadata>,
    ...
  }

  struct TokenMetadata {
    name: felt,
    description: felt,
    image: felt,
    external_url: felt,
    attributes: felt
  }

  impl NFTMint {
    ...

    fn mint(ref self: ContractState, recipient: ContractAddress, quantity: u256, metadata: TokenMetadata) {
      ...
      for i in 0 until quantity {
        let token_id: u256 = self.next_token_id.read();
        self.erc721._mint(recipient, token_id);
        self.token_metadata.write(token_id, metadata);
        ...
      }
      ...
    }

    fn token_uri(self: @ContractState, token_id: u256) -> felt {
      let metadata: TokenMetadata = self.token_metadata.read(token_id);
      return construct_token_uri(metadata);
    }
    ...
  }

  fn construct_token_uri(metadata: TokenMetadata) -> felt {
    // Logic to construct and return the token URI based on the on-chain metadata
  }
  ...
}
</code>
</pre>

<p>This example illustrates how to modify the minting function to accept metadata, store it on-chain, and utilize this metadata to generate a token URI dynamically.</p>
