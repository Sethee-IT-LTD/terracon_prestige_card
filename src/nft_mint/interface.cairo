use starknet::ContractAddress;

#[starknet::interface]
trait INFTMint<TContractState> {
    fn mint(ref self: TContractState, mint: ContractAddress);
}