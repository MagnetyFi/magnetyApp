%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_check
from starkware.starknet.common.syscalls import (
    get_block_number,
)


from openzeppelin.utils.constants import (
    TRUE, FALSE,
)
from openzeppelin.security.safemath import (
    uint256_checked_add,
    uint256_checked_sub_le,
    uint256_eq,
    uint256_lt,
)

from openzeppelin.token.erc721.library import (
    ERC721_name_,
    ERC721_symbol_,
    ERC721_name,
    ERC721_symbol,
    ERC721_balanceOf,
    ERC721_ownerOf,
    ERC721_getApproved,
    ERC721_isApprovedForAll,

    ERC721_initializer,
    ERC721_approve, 
    ERC721_setApprovalForAll,
    ERC721_only_token_owner,
    _exists

)

from openzeppelin.token.erc721_enumerable.library import (
    ERC721_Enumerable_initializer,
    ERC721_Enumerable_totalSupply,
    ERC721_Enumerable_tokenByIndex,
    ERC721_Enumerable_tokenOfOwnerByIndex,
    ERC721_Enumerable_mint,
    ERC721_Enumerable_burn,
    ERC721_Enumerable_transferFrom,
    ERC721_Enumerable_safeTransferFrom
)

from openzeppelin.introspection.ERC165 import ERC165_supports_interface


#
# Storage
#

@storage_var
func ERC721_sharesBalance(token_id: Uint256) -> (sharesAmount: Uint256):
end

@storage_var
func ERC721_sharePricePurchased(token_id: Uint256) -> (sharePricePurchased: Uint256):
end

@storage_var
func ERC721_sharesTotalSupply() -> (sharesTotalSupply: Uint256):
end

@storage_var
func ERC721_mintedBlock(token_id: Uint256) -> (mintedBlock: felt):
end




#
# Constructor
#

@external
func initialize{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        name: felt,
        symbol: felt,
    ):
    ERC721_initializer(name, symbol)
    ERC721_Enumerable_initializer()
    return ()
end

#
# Getters
#

@view
func totalSupply{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }() -> (totalSupply: Uint256):
    let (totalSupply: Uint256) = ERC721_Enumerable_totalSupply()
    return (totalSupply)
end

@view
func sharesTotalSupply{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }() -> (sharesTotalSupply: Uint256):
    let (sharesTotalSupply: Uint256) = ERC721_sharesTotalSupply.read()
    return (sharesTotalSupply)
end

@view
func tokenByIndex{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(index: Uint256) -> (tokenId: Uint256):
    let (tokenId: Uint256) = ERC721_Enumerable_tokenByIndex(index)
    return (tokenId)
end

@view
func tokenOfOwnerByIndex{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(owner: felt, index: Uint256) -> (tokenId: Uint256):
    let (tokenId: Uint256) = ERC721_Enumerable_tokenOfOwnerByIndex(owner, index)
    return (tokenId)
end

@view
func supportsInterface{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(interfaceId: felt) -> (success: felt):
    let (success) = ERC165_supports_interface(interfaceId)
    return (success)
end

@view
func name{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (name: felt):
    let (name) = ERC721_name()
    return (name)
end

@view
func symbol{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (symbol: felt):
    let (symbol) = ERC721_symbol()
    return (symbol)
end

@view
func balanceOf{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(owner: felt) -> (balance: Uint256):
    let (balance: Uint256) = ERC721_balanceOf(owner)
    return (balance)
end


@view
func ownerOf{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(tokenId: Uint256) -> (owner: felt):
    let (owner: felt) = ERC721_ownerOf(tokenId)
    return (owner)
end

@view
func getApproved{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(tokenId: Uint256) -> (approved: felt):
    let (approved: felt) = ERC721_getApproved(tokenId)
    return (approved)
end

@view
func isApprovedForAll{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(owner: felt, operator: felt) -> (isApproved: felt):
    let (isApproved: felt) = ERC721_isApprovedForAll(owner, operator)
    return (isApproved)
end

@view
func sharesBalance{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(tokenId: Uint256) -> (sharesBalance: Uint256):

    let (exists) = _exists(tokenId)
    with_attr error_message("ERC721_Metadata: sharesBalance query for nonexistent token"):
        assert exists = TRUE
    end

    let (sharesBalance: Uint256) = ERC721_sharesBalance.read(tokenId)
    return (sharesBalance)
end

@view
func sharePricePurchased{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*, 
        range_check_ptr
    }(tokenId: Uint256) -> (sharePricePurchased: Uint256):

    let (exists) = _exists(tokenId)
    with_attr error_message("ERC721_Metadata: sharePricePurchased query for nonexistent token"):
        assert exists = TRUE
    end

    let (sharePricePurchased: Uint256) = ERC721_sharePricePurchased.read(tokenId)
    return (sharePricePurchased)
end

@view
func mintedBlock{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*, 
        range_check_ptr
    }(tokenId: Uint256) -> (mintedBlock: felt):

    let (exists) = _exists(tokenId)
    with_attr error_message("ERC721_Metadata: mintedBlock query for nonexistent token"):
        assert exists = TRUE
    end

    let (mintedBlock: felt) = ERC721_mintedBlock.read(tokenId)
    return (mintedBlock)
end




#
# External
#

@external
func _setName{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(_name:felt):
    ERC721_name_.write(_name)
    return ()
end

@external
func _setSymbol{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(_symbol:felt):
    ERC721_symbol_.write(_symbol)
    return ()
end

@external
func approve{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(to: felt, tokenId: Uint256):
    ERC721_approve(to, tokenId)
    return ()
end

@external
func setApprovalForAll{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*, 
        range_check_ptr
    }(operator: felt, approved: felt):
    ERC721_setApprovalForAll(operator, approved)
    return ()
end

@external
func transferFrom{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        from_: felt, 
        to: felt, 
        tokenId: Uint256
    ):
    ERC721_Enumerable_transferFrom(from_, to, tokenId)
    return ()
end


@external
func safeTransferFrom{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        from_: felt, 
        to: felt, 
        tokenId: Uint256, 
        data_len: felt,
        data: felt*
    ):
    ERC721_Enumerable_safeTransferFrom(from_, to, tokenId, data_len, data)
    return ()
end

@external
func mint{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(to: felt, sharesAmount: Uint256, sharePricePurchased:Uint256):
    alloc_locals
    let (tokenId:Uint256) = totalSupply()
    ERC721_Enumerable_mint(to, tokenId)

    #set metadata 
    ERC721_sharesBalance.write(tokenId, sharesAmount)
    ERC721_sharePricePurchased.write(tokenId, sharePricePurchased)
    let (block_number) = get_block_number()
    ERC721_mintedBlock.write(tokenId, block_number)

    #set the new supply
    let (supply: Uint256) = ERC721_sharesTotalSupply.read()
    let (new_supply: Uint256) = uint256_checked_add(supply, sharesAmount)
    ERC721_sharesTotalSupply.write(new_supply)
    return ()
end

@external
func burn{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(tokenId: Uint256):
    uint256_check(tokenId)
    let (exists) = _exists(tokenId)
    with_attr error_message("ERC721_Metadata: sharesBalance query for nonexistent token"):
        assert exists = TRUE
    end

    let (shares:Uint256) = ERC721_sharesBalance.read(tokenId)

    #set the token id balance to 0
    ERC721_sharesBalance.write(tokenId, Uint256(0,0))

    #set the new shares supply
    let (supply:Uint256) = ERC721_sharesTotalSupply.read()
    let (new_supply:Uint256) = uint256_checked_sub_le(supply, shares)
    ERC721_sharesTotalSupply.write(new_supply)

    #burn erc721
    ERC721_Enumerable_burn(tokenId)

    return ()
end

@external
func subShares{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(tokenId: Uint256, sharesToSub:Uint256):
    alloc_locals
    uint256_check(tokenId)
    uint256_check(sharesToSub)

    let (exists) = _exists(tokenId)

    with_attr error_message("ERC721_Metadata: sharesBalance query for nonexistent token"):
        assert exists = TRUE
    end

    let (res) = uint256_eq(sharesToSub, Uint256(0,0))

    with_attr error_message("ERC721_Metadata: can not sub zero shares"):
        assert res = FALSE 
    end

    let (shares: Uint256) = ERC721_sharesBalance.read(tokenId)

    let (isLess) = uint256_lt(sharesToSub, shares)

    with_attr error_message("ERC721_Metadata: can not sub more than available shares"):
        assert isLess = TRUE
    end


    let (new_shares) = uint256_checked_sub_le(shares, sharesToSub)
    ERC721_sharesBalance.write(tokenId, new_shares)

    #set the new shares supply
    let (supply:Uint256) = ERC721_sharesTotalSupply.read()
    let (new_supply:Uint256) = uint256_checked_sub_le(supply, sharesToSub)
    ERC721_sharesTotalSupply.write(new_supply)

    return ()
end




