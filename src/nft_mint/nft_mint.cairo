const MAX_SUPPLY: u32 = 1000;
const MAX_TOKENS_PER_ADDRESS: u32 = 20;

#[starknet::contract]
mod NFTMint {
    use openzeppelin::access::ownable::OwnableComponent;
    use starknet::ContractAddress;
    use openzeppelin::token::erc20::interface::{
        IERC20, IERC20Metadata, ERC20ABIDispatcher, ERC20ABIDispatcherTrait
    };
    use terracon_prestige_card::nft_mint::interface::INFTMint;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    #[abi(embed_v0)]
    impl OwnableCamelOnlyImpl =
        OwnableComponent::OwnableCamelOnlyImpl<ContractState>;
    impl InternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: OwnableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        // Set the initial owner of the contract
        self.ownable.initializer(owner);
    }

    impl NFTMint of INFTMint<ContractState> {
        fn mint(ref self: ContractState, mint: ContractAddress){

        };
    }
}