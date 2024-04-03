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

<h1>On-Chain Metadata Storage for Starknet Contract</h1>

<p>To store metadata directly on the blockchain, you can define a structure representing the metadata and adjust the contract for storage and retrieval. This guide outlines the implementation using Cairo 2.0 syntax:</p>

<h2>1. Define the TokenMetadata Struct</h2>
<p>First, define a <code>TokenMetadata</code> struct that includes the necessary fields for an NFT's metadata, as well as an array of <code>Attribute</code> structs for customizable properties.</p>

<pre><code>#[derive(Drop, Serde)]
struct Attribute {
    trait_type: felt252,
    value: felt252,
}

#[derive(Drop, Serde)]
struct TokenMetadata {
    name: felt252,
    description: felt252,
    image: felt252,
    external_url: felt252,
    attributes: Array&lt;Attribute&gt;,
}</code></pre>

<p>This struct encompasses fields for the name, description, image URL, external URL, and an array of attributes.</p>

<h2>2. Add Storage Variable</h2>
<p>Integrate a new storage variable within the <code>Storage</code> struct to link token IDs with their corresponding metadata.</p>

<pre><code>struct Storage {
    // ...
    token_metadata: LegacyMap&lt;u256, TokenMetadata&gt;,
    // ...
}</code></pre>

<h2>3. Modify the <code>_mint</code> Function</h2>
<p>Adjust the <code>_mint</code> function to accept metadata as an input parameter and store it using the token's ID as the key.</p>

<pre><code>fn _mint(ref self: ContractState, recipient: ContractAddress, token_id: u256, metadata: TokenMetadata) {
    // ...
    self.token_metadata.write(token_id, metadata);
    // ...
}</code></pre>

<h2>4. Update the <code>token_uri</code> Function</h2>
<p>Revise the <code>token_uri</code> function to retrieve the metadata from storage and convert it to a JSON string before returning.</p>

<pre><code>fn token_uri(self: @ContractState, token_id: u256) -> felt252 {
    let metadata = self.token_metadata.read(token_id);
    // Convert the metadata to a JSON string and return it
    return metadata.to_json();
}</code></pre>

<h2>5. Update the Minting Process</h2>
<p>Modify the minting process to include metadata for each minted token, ensuring the metadata is passed to the <code>_mint</code> function.</p>

<pre><code>fn mint(ref self: ContractState, recipient: ContractAddress, quantity: u256, metadata: TokenMetadata) {
    // ...
    let mut token_id = self.next_token_id.read();
    for _ in 0 until quantity {
        self._mint(recipient, token_id, metadata);
        token_id += 1;
    }
    self.next_token_id.write(token_id);
    // ...
}</code></pre>

<p>With these adjustments, the contract will now store each token's metadata on the blockchain, making it accessible through the <code>token_uri</code> function.</p>

<p><strong>Note:</strong> The <code>to_json</code> function in the <code>token_uri</code> function is a placeholder for a method that converts the <code>TokenMetadata</code> struct to a JSON string. This function must be implemented separately or utilize a JSON serialization library compatible with Cairo.</p>

<p>Remember to revise the <code>INFTMint</code> interface and any other relevant contract sections to reflect the incorporation of on-chain metadata storage.</p>
