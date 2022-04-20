%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (
    get_caller_address, 
    get_contract_address,
)

from starkware.cairo.common.math import (
    assert_not_zero,
    assert_not_equal,
    assert_le,
)

from starkware.cairo.common.memcpy import memcpy


from openzeppelin.token.erc20.interfaces.IERC20 import IERC20

from utils.utils import (
    felt_to_uint256,
)

from starkware.cairo.common.alloc import (
    alloc,
)

from starkware.cairo.common.find_element import (
    find_element,
)


from starkware.cairo.common.uint256 import (
    Uint256, 
    uint256_check,
    uint256_le,
    uint256_eq,
)

from openzeppelin.security.safemath import (
    uint256_checked_add,
    uint256_checked_sub_le,
)

from IVault import (
    VaultAction
)

from interface.IExternalPosition import IExternalPosition



from shareBaseToken import (

    #NFT Shares getters
    totalSupply,
    sharesTotalSupply,
    name,
    symbol,
    balanceOf,
    ownerOf,
    sharesBalance,
    sharePricePurchased,
    mintedBlock,

    #NFT Shares externals
    transferSharesFrom,
    mint,
    burn,
    subShares,

    #init
    initializeShares,
)

from vaultLibBaseCore import (

    comptrolleur,

    trackedAssets,
    trackedAssetsLength,
    assetToIsTracked,
    assetToId,

    positionLimit,

    init,
    onlyVaultComptrolleur,
)


#
# Events
#

@event
func AssetWithdrawn(assetAddress: felt, targetAddress: felt, amount: Uint256):
end

@event
func TrackedAssetAdded(assetAddress: felt):
end

@event
func TrackedAssetRemoved(assetAddress: felt):
end

# @event
# func NameSet(name: felt):
# end

# @event
# func SymbolSet(symbol: felt):
# end

const FALSE = 0
const TRUE = 1


#
# Getters 
#


func isTrackedAsset{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_asset: felt) -> (isTrackedAsset_: felt):
    let (isTrackedAsset_:felt) = assetToIsTracked.read(_asset)
    if isTrackedAsset_ == 0:
        return (FALSE)
    end
        return(TRUE)
end

func getTrackedAssets{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (trackedAssets_len_:Uint256, trackedAssets_: felt*):
    alloc_locals
    let (trackedAssets_len_:Uint256) = trackedAssetsLength.read()
    let (local trackedAssets_ : felt*) = alloc()
    completeAssetTab(trackedAssets_len_, trackedAssets_, 0)
    return(trackedAssets_len_, trackedAssets_)
end

func completeAssetTab{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(trackedAssets_len_:Uint256, trackedAssets_:felt*, index:felt) -> ():
    let (isEmpty) = uint256_eq(trackedAssets_len_, Uint256(0,0))
    if isEmpty == 1:
        return ()
    end
    let (indexUint256_:Uint256) = felt_to_uint256(index)
    let (trackedAsset_:felt) = trackedAssets.read(indexUint256_)

    assert [trackedAssets_ + index] = trackedAsset_
    

    let new_index_:felt = index + 1
    let (new_trackedAssets_len_:Uint256) = uint256_checked_sub_le(trackedAssets_len_, Uint256(1,0))

    return completeAssetTab(
        trackedAssets_len_=new_trackedAssets_len_,
        trackedAssets_= trackedAssets_,
        index=new_index_,
    )
end


func getPositionsLimit{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (positionLimit_: Uint256):
    let (positionLimit_:Uint256) = positionLimit.read()
    return (positionLimit_)
end

func getAssetBalance{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_asset: felt) -> (assetBalance_: Uint256):
    let (account_:felt) = get_contract_address()
    let (assetBalance_:Uint256) = IERC20.balanceOf(contract_address=_asset, account=account_)
    return (assetBalance_)
end

@view
func getComptrolleur{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (comptrolleurAd: felt):
    let (comptrolleurAd: felt) = comptrolleur.read()
    return (comptrolleurAd)
end

#
# NFT Getters 
#

@view
func getTotalSupply{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }() -> (totalSupply: Uint256):
    let (totalSupply: Uint256) = totalSupply()
    return (totalSupply)
end

@view
func getSharesTotalSupply{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }() -> (sharesTotalSupply: Uint256):
    let (sharesTotalSupply: Uint256) = sharesTotalSupply()
    return (sharesTotalSupply)
end




@view
func getName{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (name: felt):
    let (name) = name()
    return (name)
end

@view
func getSymbol{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (symbol: felt):
    let (symbol) = symbol()
    return (symbol)
end

@view
func getBalanceOf{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(owner: felt) -> (balance: Uint256):
    let (balance: Uint256) = balanceOf(owner)
    return (balance)
end


@view
func getOwnerOf{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(tokenId: Uint256) -> (owner: felt):
    let (owner: felt) = ownerOf(tokenId)
    return (owner)
end



@view
func getSharesBalance{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(tokenId: Uint256) -> (sharesBalance: Uint256):
    let (sharesBalance: Uint256) = sharesBalance(tokenId)
    return (sharesBalance)
end

@view
func getSharePricePurchased{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*, 
        range_check_ptr
    }(tokenId: Uint256) -> (sharePricePurchased: Uint256):
    let (sharePricePurchased: Uint256) = sharePricePurchased(tokenId)
    return (sharePricePurchased)
end

@view
func getMintedBlock{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*, 
        range_check_ptr
    }(tokenId: Uint256) -> (mintedBlock: felt):
    let (mintedBlock: felt) = mintedBlock(tokenId)
    return (mintedBlock)
end

#
# Constructor
#
@constructor
func constructor{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        _fundName: felt,
        _symbol: felt,
        _comptrolleur: felt,
        _positionLimitAmount: Uint256,
    ):
    initializeShares(_fundName, _symbol)
    init(_comptrolleur, _positionLimitAmount)
    return ()
end


#
# externals
#



func addTrackedAsset{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _asset: felt, 
    ):
    onlyVaultComptrolleur()
    __addTrackedAsset(_asset)
    return ()
end


func burnShares{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _amount: Uint256,
        _tokenId:Uint256,
    ):
    alloc_locals
    let(_comptrolleur:felt) = comptrolleur.read()
    let(_caller:felt) = get_caller_address()
    let(_shareowner:felt)  = ownerOf(_tokenId)

    with_attr error_message("burnShares: approve caller is not owner nor approved for all"):
        assert (_comptrolleur - _caller) * (_shareowner - _caller) = 0
    end

    let(_sharesAmount:Uint256) = sharesBalance(_tokenId)
    let (equal_) = uint256_eq(_sharesAmount, _amount)
    if equal_ == TRUE:
        burn(_tokenId)
        return ()
    else:
        subShares(_tokenId, _amount)
        return ()
    end
end


func mintShares{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _amount: Uint256,
        _newSharesholder:felt,
        _sharePricePurchased:Uint256,
    ):
    onlyVaultComptrolleur()
    let (_tokenId:Uint256) = totalSupply()
   mint(_newSharesholder, _amount, _sharePricePurchased)
   return ()
end



func receiveValidatedVaultAction{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _action: felt,
        _actionData_len:felt,
        _actionData:felt*,
    ):
    alloc_locals
    onlyVaultComptrolleur()
    if  _action == VaultAction.AddTrackedAsset : 
        __executeVaultActionAddTrackedAsset(_actionData)
        return ()
        else:
            if _action == VaultAction.BurnShares:
                __executeVaultActionBurnShares(_actionData)
                return ()
                else:
                    if _action == VaultAction.MintShares:
                        __executeVaultActionMintShares(_actionData)
                        return ()
                        else:
                            if _action == VaultAction.RemoveTrackedAsset:
                                __executeVaultActionRemoveTrackedAsset(_actionData)
                                return ()
                                else:
                                    if _action == VaultAction.TransferShares:
                                        __executeVaultActionTransferShares(_actionData)
                                        return ()
                                        else:
                                            if _action == VaultAction.WithdrawAssetTo:
                                                __executeVaultActionWithdrawAssetTo(_actionData)
                                                return ()
                                            end
                                        end
                                end
                        end
                end
        end
    return ()
end




#
# VAULT ACTION DISPATCH
#


func __executeVaultActionAddTrackedAsset{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let address_:felt = _actionData[0]
    __addTrackedAsset(address_)
    return ()
end

func __executeVaultActionRemoveTrackedAsset{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let address_:felt = _actionData[0]
    __removeTrackedAsset(address_)
    return ()
end


func __executeVaultActionBurnShares{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (tokenId_:Uint256) = felt_to_uint256(_actionData[0])
    let (amount_:Uint256) = felt_to_uint256(_actionData[1])
    burnShares(amount_, tokenId_)
    return ()
end

func __executeVaultActionMintShares{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let newSharesholder_:felt = _actionData[0]
    let (amount_:Uint256) = felt_to_uint256(_actionData[1])
    let (sharePricePurchased_:Uint256) = felt_to_uint256(_actionData[2])
    mintShares(amount_, newSharesholder_, sharePricePurchased_)
    return ()
end


func __executeVaultActionTransferShares{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let from_:felt = _actionData[0]
    let to_:felt = _actionData[1]
    let (tokenId_:Uint256) = felt_to_uint256(_actionData[2])
    transferSharesFrom(from_, to_, tokenId_)
    return ()
end

func __executeVaultActionWithdrawAssetTo{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let asset_:felt = _actionData[0]
    let target_:felt = _actionData[1]
    let (amount_:Uint256) = felt_to_uint256(_actionData[2])
    __withdrawAssetTo(asset_, target_, amount_)
    return ()
end

#
# VAULT ACTION 
#

func __addTrackedAsset{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_asset: felt):

    let (isTrackedAsset_:felt) = isTrackedAsset(_asset)
    with_attr error_message("__addTrackedAsset: asset already tracked"):
        assert isTrackedAsset_ = FALSE
    end
    __validatePositionsLimit()
    let (currentTrackedAssetsLength: Uint256) = trackedAssetsLength.read()
    assetToIsTracked.write(_asset,TRUE)
    trackedAssets.write(currentTrackedAssetsLength,_asset)
    assetToId.write(_asset,currentTrackedAssetsLength)
    let (newTrackedAssetsLength_: Uint256) = uint256_checked_add(currentTrackedAssetsLength,Uint256(1,0))
    trackedAssetsLength.write(newTrackedAssetsLength_)
    TrackedAssetAdded.emit(_asset)
    return ()
end

func __removeTrackedAsset{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_asset: felt):
    alloc_locals
    let (isTrackedAsset_:felt) = isTrackedAsset(_asset)
    with_attr error_message("__removeTrackedAsset: asset not tracked"):
        assert isTrackedAsset_ = TRUE
    end
    assetToIsTracked.write(_asset,FALSE)
    let (currentTrackedAssetsLength_: Uint256) = trackedAssetsLength.read()
    let (id:Uint256) = assetToId.read(_asset)
    let (res:Uint256) = uint256_checked_sub_le(currentTrackedAssetsLength_, id)
    let (newTrackedAssetsLength_: Uint256) = uint256_checked_sub_le(currentTrackedAssetsLength_,Uint256(1,0))
    let (isEqual_) = uint256_eq(res, Uint256(1,0))
    if isEqual_ == TRUE: 
    trackedAssets.write(id, 0)
    else:
        let lastAssetId:Uint256 = newTrackedAssetsLength_
        let (lastAsset:felt) = trackedAssets.read(lastAssetId)
        trackedAssets.write(lastAssetId, 0)
        trackedAssets.write(id, lastAsset)
        assetToId.write(lastAsset, id)
    end
    trackedAssetsLength.write(newTrackedAssetsLength_)
    TrackedAssetRemoved.emit(_asset)
    return ()
end


func __validatePositionsLimit{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }():
    alloc_locals
    let (positionLimit_:Uint256) = getPositionsLimit()
    let (trackedAssetsLength_:Uint256) = trackedAssetsLength.read()
    let (activeExternalPositionsLength_:Uint256) = activeExternalPositionsLength.read()
    let (res_:Uint256) = uint256_checked_add(trackedAssetsLength_, activeExternalPositionsLength_)
    let (res__) = uint256_le(res_, positionLimit_)
    with_attr error_message("__validatePositionsLimit: Limit exceeded"):
        assert res__ = TRUE
    end
    return ()
end

func __withdrawAssetTo{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        _asset: felt,
        _target:felt,
        _amount:Uint256,
    ):
    let (_success) = IERC20.transfer(contract_address = _asset,recipient = _target,amount = _amount)
    with_attr error_message("__withdrawAssetTo: transfer didn't work"):
        assert_not_zero(_success)
    end

    AssetWithdrawn.emit(_asset, _target, _amount)
    return ()
end