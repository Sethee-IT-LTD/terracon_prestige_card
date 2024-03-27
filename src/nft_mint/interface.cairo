use starknet::ContractAddress;

#[starknet::interface]
pub trait INFTMint<TContractState> {
    fn mint(ref self: TContractState, recipient: ContractAddress, quantity: u256);
    fn set_public_sale_open(ref self: TContractState, public_sale_open: bool);
    // fn set_whitelist_merkle_root(ref self: TContractState, whitelist_merkle_root: felt252);
    fn whitelist_addresses(ref self: TContractState, address_1: ContractAddress, address_2: ContractAddress, address_3: ContractAddress, address_4: ContractAddress, address_5: ContractAddress);
    // fn is_public_sale_open(self: @TContractState) -> bool;
    // fn get_whitelist_merkle_root(self: @TContractState) -> felt252;
    // fn get_whitelist_allocation(
    //     self: @TContractState, account: ContractAddress, allocation: felt252, proof: Span<felt252>
    // ) -> felt252;
}