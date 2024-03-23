#[starknet::contract]
mod NFTMint {
    use core::zeroable::Zeroable;
    use starknet::{ContractAddress, get_block_timestamp};
    use openzeppelin::token::erc721::ERC721Component;
    use openzeppelin::introspection::src5::SRC5Component;
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::token::erc20::interface::{
        IERC20, IERC20Metadata, ERC20ABIDispatcher, ERC20ABIDispatcherTrait
    };
    use alexandria_data_structures::merkle_tree::{ Hasher, MerkleTree, poseidon::PoseidonHasherImpl, MerkleTreeTrait };
    use terracon_prestige_card::nft_mint::{INFTMint};
    use terracon_prestige_card::errors::{MAX_SUPPLY_REACHED, INVALID_RECIPIENT, PUBLIC_SALE_NOT_STARTED};

    const MAX_SUPPLY: u256 = 1000;
    const MAX_TOKENS_PER_ADDRESS: u256 = 20;

    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl ERC721MetadataImpl = ERC721Component::ERC721MetadataImpl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;
    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl InternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        public_sale_open: bool,
        whitelist_merkle_root: felt252,
        #[substorage(v0)]
        erc721: ERC721Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        PreSaleOpen: PreSaleOpen,
        PreSaleClose: PreSaleClose,
        PublicSaleOpen: PublicSaleOpen,
        PublicSaleClose: PublicSaleClose,
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event
    }

    #[derive(Drop, starknet::Event)]
    struct PreSaleOpen {
        time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct PreSaleClose {
        time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct PublicSaleOpen {
        time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct PublicSaleClose {
        time: u64
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        let name = 'Terracon Hex Prestige Card';
        let symbol = 'HEX';

        self.erc721.initializer(name, symbol);
        // Set the initial owner of the contract
        self.ownable.initializer(owner);
    }

    #[abi(embed_v0)]
    impl NFTMint of INFTMint<ContractState> {
        fn mint(ref self: ContractState, recipient: ContractAddress, token_id: u256) {
            assert(!recipient.is_zero(), INVALID_RECIPIENT);
            assert(token_id <= MAX_SUPPLY, MAX_SUPPLY_REACHED);
            assert(self.public_sale_open.read() == true, PUBLIC_SALE_NOT_STARTED);
            // assert(self.erc721.balance_of(recipient) < MAX_TOKENS_PER_ADDRESS, 'Maximum NFT per address reached');
            let token_uri: felt252 = 'bit.ly/42TzZaT';
            self.erc721._mint(recipient, token_id);
            self.erc721._set_token_uri(token_id, token_uri);
        }

        fn set_public_sale_open(ref self: ContractState, public_sale_open: bool) {
            self.public_sale_open.write(public_sale_open);

            let current_time = get_block_timestamp();
            if public_sale_open {
                self.emit(Event::PublicSaleOpen(PublicSaleOpen { time: current_time }));
            } else {
                self.emit(Event::PublicSaleClose(PublicSaleClose { time: current_time }));
            };
        }

        fn set_whitelist_merkle_root(ref self: ContractState, whitelist_merkle_root: felt252) {
            self.whitelist_merkle_root.write(whitelist_merkle_root);

            let current_time = get_block_timestamp();
            if whitelist_merkle_root != 0 {
                self.emit(Event::PreSaleOpen(PreSaleOpen { time: current_time }));
            } else {
                self.emit(Event::PreSaleClose(PreSaleClose { time: current_time }));
            };
        }
    }
}