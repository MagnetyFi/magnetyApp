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
    tokenByIndex,
    tokenOfOwnerByIndex,
    supportsInterface,
    name,
    symbol,
    balanceOf,
    ownerOf,
    getApproved,
    isApprovedForAll,
    sharesBalance,
    sharePricePurchased,
    mintedBlock,

    _setName,
    _setSymbol,
    approve,
    setApprovalForAll,
    transferSharesFrom,
    mint,
    burn,
    subShares,

    #init
    initializeShares,
)

from vaultLibBaseCore import (

    comptrolleur,
    migrator,
    owner,
    vaultLib,
    externalPositionManager,

    trackedAssets,
    activeExternalPositions,
    trackedAssetsLength,
    activeExternalPositionsLength,
    assetToIsTracked,
    externalPositionToIsActive,
    assetToId,
    externalPositionToId,

    positionLimit,

    accountToIsAssetManager,
    nominatedOwner,

    init,
    onlyVaultComptrolleur,
    onlyMigrator,
    setVaultLib,
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

@event
func AssetManagerAdded(assetManagerAddress: felt):
end

@event
func AssetManagerRemoved(assetManagerAddress: felt):
end

@event
func ExternalPositionAdded(externalPositionAddress: felt):
end

@event
func ExternalPositionRemoved(externalPositionAddress: felt):
end

@event
func NameSet(name: felt):
end

@event
func SymbolSet(symbol: felt):
end

@event
func NominatedOwnerSet(nominatedOwnerAddress: felt):
end

@event
func NominatedOwnerRemoved(nominatedOwnerAddress: felt):
end

@event
func OwnershipTransferred(prevOwner: felt, nextOwner:felt):
end



const FALSE = 0
const TRUE = 1


#
# Getters
#


func isAssetManager{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(who: felt) -> (isAssetManager_: felt):
    let (isAssetManager_:felt) = accountToIsAssetManager.read(who)
    if isAssetManager_ == 0:
        return (FALSE)
    end
        return(TRUE)
end

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

func isActiveExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_externalPosition: felt) -> (isActiveExternalPosition_: felt):
    let (isActiveExternalPosition_:felt) = externalPositionToIsActive.read(_externalPosition)
    if isActiveExternalPosition_ == 0:
        return (FALSE)
    end
        return(TRUE)
end


# CALL migration manager to get the funddeployer for this proxy
# func getFundDeployer{
#         syscall_ptr: felt*,
#         pedersen_ptr: HashBuiltin*,
#         range_check_ptr
#     }() -> (fundDeployer_: felt):
    

#     return fundDeployer_
# end

func getExternalPositionManager{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (externalPositionManager_: felt):
    let (externalPositionManager_:felt) = externalPositionManager.read()
    return (externalPositionManager_)
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
func getVaultLib{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (vaultLibAd: felt):
    let (vaultLibAd: felt) = vaultLib.read()
    return (vaultLibAd)
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

# @view
# func getVaultFactory{
#         syscall_ptr : felt*, 
#         pedersen_ptr : HashBuiltin*,
#         range_check_ptr
#     }() -> (vaultFactoryAd: felt):
#     let (vaultFactoryAd: felt) = vaultFactory.read()
#     return (vaultFactoryAd)
# end

@view
func getOwner{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (ownerAd: felt):
    let (ownerAd: felt) = owner.read()
    return (ownerAd)
end

@view
func getMigrator{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (migratorAd: felt):
    let (migratorAd: felt) = migrator.read()
    return (migratorAd)
end



@view
func canMigrate{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(who: felt) -> (canMigrate: felt):
    let (owner_: felt) = owner.read()
    let (migrator_: felt) = migrator.read()
    let isAllowed_: felt = (who - owner_) * (who - migrator_)

    if isAllowed_ == 0:
        return (TRUE)
    end
        return(FALSE)
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
        _owner: felt,
        _vaultLib: felt,
        _externalPositionManager: felt,
        _positionLimitAmount: Uint256,
    ):
    initializeShares(_fundName, _symbol)
    init(_owner, _comptrolleur, _vaultLib, _externalPositionManager, _positionLimitAmount)
    return ()
end


#
# externals
#

func setName{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _nextName: felt, 
    ):
    onlyVaultComptrolleur()
    _setName(_nextName)
    NameSet.emit(_nextName)
    return ()
end

func setSymbol{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _nextSymbol: felt, 
    ):
    onlyVaultComptrolleur()
    _setSymbol(_nextSymbol)
    SymbolSet.emit(_nextSymbol)
    return ()
end

func addAssetManager{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _manager: felt, 
    ):
    onlyVaultComptrolleur()
    let (isregistred_: felt) = isAssetManager(_manager)
    with_attr error_message("addAssetManager: asset manager already registred"):
        assert isregistred_ = 0
    end
    
    accountToIsAssetManager.write(_manager, TRUE)
    AssetManagerAdded.emit(_manager)
    return ()
end

func claimOwnership{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(_nextOwner: felt):
    onlyVaultComptrolleur()
    let (nextOwner: felt) = nominatedOwner.read()

    with_attr error_message("claimOwnership: Only the nominatedOwner can call this function"):
        assert _nextOwner - nextOwner = 0
    end

    nominatedOwner.write(0)

    let (prevOwner:felt) = owner.read()
    owner.write(_nextOwner)

    OwnershipTransferred.emit(prevOwner, _nextOwner)
    return ()
end

func setNominatedOwner{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(_nextNominatedOwner: felt):
    onlyVaultComptrolleur()
    let (currentOwner: felt) = owner.read()

    with_attr error_message("setNominatedOwner: _nextNominatedOwner is already the owner"):
        assert_not_equal(_nextNominatedOwner, currentOwner)
    end

    with_attr error_message("setNominatedOwner: _nextNominatedOwner cannot be empt"):
        assert_not_zero(_nextNominatedOwner)
    end

    let (currentNominatedOwner:felt) = nominatedOwner.read()

    with_attr error_message("setNominatedOwner: _nextNominatedOwner cannot be empt"):
        assert_not_equal(_nextNominatedOwner, currentNominatedOwner)
    end

    nominatedOwner.write(_nextNominatedOwner)

    NominatedOwnerSet.emit(_nextNominatedOwner)
    return ()
end


func removeNominatedOwner{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(_currentOwner: felt):
    onlyVaultComptrolleur()
    let (currentOwner: felt) = owner.read()

    with_attr error_message("removeNominatedOwner: Only the owner can call this function"):
        assert _currentOwner - currentOwner = 0
    end

    let (removedNominatedOwner:felt) = nominatedOwner.read()

    with_attr error_message("removeNominatedOwner: There is no nominated owner"):
        assert_not_zero(removedNominatedOwner)
    end

    nominatedOwner.write(0)

    NominatedOwnerRemoved.emit(removedNominatedOwner)
    return ()
end

func removeAssetManager{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _manager: felt, 
    ):
    onlyVaultComptrolleur()
    let (isregistred: felt) = isAssetManager(_manager)
    with_attr error_message("addAssetManager: asset manager not registred"):
        assert isregistred = 1
    end

    accountToIsAssetManager.write(_manager, FALSE)
    AssetManagerRemoved.emit(_manager)
    return ()
end

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

# func callOnContract{
#         pedersen_ptr: HashBuiltin*, 
#         syscall_ptr: felt*, 
#         range_check_ptr
#     }(
#         _contract:felt,
        
#     ):
#     let(_comptrolleur:felt) = comptrolleur.read()
#     let(_caller:felt) = get_caller_address()
#     let(_shareowner:felt)  = ownerOf(_tokenId)

#     with_attr error_message("burnShares: approve caller is not owner nor approved for all"):
#         assert (_comptrolleur - _caller) * (_shareowner - _caller) = 0
#     end

#     let(_sharesAmount:felt) = sharesBalance(_tokenId)

#     if _sharesAmount == _amount:
#         burn(token_id)
#         return ()
#     else:
#         subShares(_tokenId, _amount)
#         return ()
#     end
# end



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

func transferShares{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _from: felt,
        _to:felt,
        _tokenId:Uint256,
    ):
    onlyVaultComptrolleur()
    transferSharesFrom(_from, _to, _tokenId)
    return ()
end

func withdrawAssetTo{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _asset: felt,
        _target:felt,
        _amount:Uint256,
    ):
    onlyVaultComptrolleur()
    __withdrawAssetTo(_asset, _target, _amount)
    return ()
end

func receiveValidatedVaultAction{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _action: felt,
        _actionData:felt*,
    ):
    alloc_locals
    onlyVaultComptrolleur()
    if _action == VaultAction.AddExternalPosition :
         __executeVaultActionAddExternalPosition(_actionData)
         return ()
    else:
        if _action == VaultAction.AddTrackedAsset : 
            __executeVaultActionAddTrackedAsset(_actionData)
            return ()
        else:
            if _action == VaultAction.ApproveAssetSpender:
                __executeVaultActionApproveAssetSpender(_actionData)
                return ()
            else:
                if _action == VaultAction.BurnShares:
                    __executeVaultActionBurnShares(_actionData)
                    return ()
                else:
                    if _action == VaultAction.CallOnExternalPosition:
                        __executeVaultActionCallOnExternalPosition(_actionData)
                        return ()
                    else:
                        if _action == VaultAction.MintShares:
                            __executeVaultActionMintShares(_actionData)
                            return ()
                        else:
                            if _action == VaultAction.RemoveExternalPosition:
                                __executeVaultActionRemoveExternalPosition(_actionData)
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
                end
            end
        end    
    end
    return ()
end




#
# VAULT ACTION DISPATCH
#

func __executeVaultActionAddExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let address_:felt = _actionData[0]
    __addExternalPosition(address_)
    return ()
end

func __executeVaultActionAddTrackedAsset{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let address_:felt = _actionData[0]
    __addTrackedAsset(address_)
    return ()
end

func __executeVaultActionApproveAssetSpender{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let address_:felt = _actionData[0]
    let target_:felt = _actionData[1]
    let amount_:Uint256 = felt_to_uint256(_actionData[2])
    __approveAssetSpender(address_, target_, amount_)
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

func __executeVaultActionCallOnExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    alloc_locals
    let externalPosition_:felt = _actionData[0]
    #CallOnExternalPositionActionData
    let callOnExternalPositionActionDataLength_:felt = (_actionData[1])
    let (local callOnExternalPositionActionData_ : felt*) = alloc()
    memcpy(callOnExternalPositionActionData_, _actionData + 2, callOnExternalPositionActionDataLength_)
    #AssetToTransfer
    let currentIndex_:felt = 2 + callOnExternalPositionActionDataLength_
    let assetsToTransferLength_:felt = _actionData[currentIndex_]
    let (local assetsToTransfer_: felt*) = alloc()
    memcpy(assetsToTransfer_, _actionData + currentIndex_ + 1, assetsToTransferLength_)
    let (local amountsToTransferFelt_: felt*) = alloc()
    memcpy(amountsToTransferFelt_, _actionData + currentIndex_ + 1 + assetsToTransferLength_, assetsToTransferLength_)
    let (local amountsToTransfer_: Uint256*) = alloc()
    recursionUint256(amountsToTransfer_, amountsToTransferFelt_, assetsToTransferLength_)
    let (local assetsToReceive_: felt*) = alloc()
    let currentIndex2_: felt =  currentIndex_ + 1 + 2*assetsToTransferLength_
    let assetsToReceiveLength_: felt = _actionData[currentIndex2_]
    memcpy(assetsToReceive_, _actionData + currentIndex2_ + 1, assetsToReceiveLength_)

    __callOnExternalPosition(
        externalPosition_,
        callOnExternalPositionActionDataLength_,
        callOnExternalPositionActionData_,
        assetsToTransferLength_,
        assetsToTransfer_,
        amountsToTransfer_,
        assetsToReceiveLength_,
        assetsToReceive_)
    return ()
end


func recursionUint256{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt
}(
    dst: Uint256*,
    src: felt*,
    array_len: felt,
):
    if array_len == 0:
        return ()
    end
    let value_:felt = src[0]
    let (Uint256Value_:Uint256) = felt_to_uint256(value_)
    assert [dst] = Uint256Value_
    return recursionUint256(
        dst=dst + 1,
        src=src+1,
        array_len=array_len - 1,
    )
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

func __executeVaultActionRemoveExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let address_:felt = _actionData[0]
    __removeExternalPosition(address_)
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

func __addExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_externalPosition: felt):

    let (isActiveExternalPosition_:felt) = isActiveExternalPosition(_externalPosition)
    with_attr error_message("_addExternalPosition: externalPosition already active"):
        assert isActiveExternalPosition_ = FALSE
    end
    __validatePositionsLimit()
    let (currentActiveExternalPositionsLength_: Uint256) = activeExternalPositionsLength.read()
    externalPositionToIsActive.write(_externalPosition,TRUE)
    activeExternalPositions.write(currentActiveExternalPositionsLength_, _externalPosition)
    externalPositionToId.write(_externalPosition,currentActiveExternalPositionsLength_)
    let (newActiveExternalPositionsLength_: Uint256) = uint256_checked_add(currentActiveExternalPositionsLength_,Uint256(1,0))
    activeExternalPositionsLength.write(newActiveExternalPositionsLength_)
    ExternalPositionAdded.emit(_externalPosition)
    return ()
end

func __removeExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_externalPosition: felt):
    alloc_locals
    let (isActiveExternalPosition_:felt) = isActiveExternalPosition(_externalPosition)

    with_attr error_message("__removeExternalPosition: externalPosition not active"):
        assert isActiveExternalPosition_ = TRUE
    end

    externalPositionToIsActive.write(_externalPosition,FALSE)

    let (currentActiveExternalPositionsLength_: Uint256) = activeExternalPositionsLength.read()
    let (id:Uint256) = externalPositionToId.read(_externalPosition)
    let (res:Uint256) = uint256_checked_sub_le(currentActiveExternalPositionsLength_, id)
    let (newActiveExternalPositionsLength_: Uint256) = uint256_checked_sub_le(currentActiveExternalPositionsLength_,Uint256(1,0))
    let (isEqual_) = uint256_eq(res, Uint256(1,0))
    if isEqual_ == TRUE: 
    activeExternalPositions.write(id, 0)
    else :
    let lastExternalPositionId:Uint256 = newActiveExternalPositionsLength_
    let (lastExternalPosition:felt) = activeExternalPositions.read(lastExternalPositionId)
    activeExternalPositions.write(lastExternalPositionId, 0)
    activeExternalPositions.write(id, lastExternalPosition)
    externalPositionToId.write(lastExternalPosition, id)
    end
    activeExternalPositionsLength.write(newActiveExternalPositionsLength_)
    ExternalPositionRemoved.emit(_externalPosition)
    return ()
end

func __callOnExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_externalPosition: felt,
    _callOnExternalPositionActionDataLength: felt,
    _callOnExternalPositionActionData: felt*,
    _assetsToTransferLength: felt,
    _assetsToTransfer: felt*,
    _amountsToTransfer: Uint256*,
    _assetsToReceiveLength: felt,
    _assetsToReceive_: felt*):
    alloc_locals
    let (isActiveExternalPosition_:felt) = isActiveExternalPosition(_externalPosition)

    with_attr error_message("__callOnExternalPosition: externalPosition not active"):
        assert isActiveExternalPosition_ = TRUE
    end
    recursionTransfer(_externalPosition, _assetsToTransfer, _amountsToTransfer, _assetsToTransferLength)
    recursionTrack(_assetsToTransfer, _assetsToTransferLength)
 
    IExternalPosition.receiveCallFromVault(contract_address = _externalPosition,_actionData_len=_callOnExternalPositionActionDataLength, _actionData = _callOnExternalPositionActionData)
    return ()
end

func recursionTransfer{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt
}(
    _externalPosition:felt,
    _arrayAssets: felt*,
    _arrayAmounts: Uint256*,
    _array_len: felt,
):
    if _array_len == 0:
        return ()
    end

    let assetAddress_:felt = _arrayAssets[0]
    let assetAmount_:Uint256 = _arrayAmounts[0]
    __withdrawAssetTo(assetAddress_, _externalPosition, assetAmount_)

    return recursionTransfer(
        _externalPosition= _externalPosition,
        _arrayAssets=_arrayAssets + 1,
        _arrayAmounts=_arrayAmounts+1,
        _array_len=_array_len - 1,
    )
end

func recursionTrack{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr: felt
}(
    _arrayAssets: felt*,
    _array_len: felt,
):
    if _array_len == 0:
        return ()
    end

    let assetAddress_:felt = _arrayAssets[0]
    __addTrackedAsset(assetAddress_)

    return recursionTrack(
        _arrayAssets= _arrayAssets + 1,
        _array_len=_array_len - 1,
    )
end



func __approveAssetSpender{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
    _asset: felt,
    _target: felt,
    _amount: Uint256,
    ):
    alloc_locals
    let (vaultProxyAddress_: felt) = get_contract_address()
    let (allowanceAmount_ : Uint256) = IERC20.allowance(contract_address = _asset, owner = vaultProxyAddress_, spender = _target)
    let (existingAllowance) = uint256_le(Uint256(0,0),allowanceAmount_)

    # tempvar pedersen_ptr = pedersen_ptr
    # tempvar range_check_ptr = range_check_ptr

    if existingAllowance == 1 :
        let (success_) = IERC20.approve(contract_address = _asset, spender = _target, amount = Uint256(0,0))  
        with_attr error_message("__approveAssetSpender: Approve didn't succeed"):
            assert_not_zero(success_)
        end
        tempvar syscall_ptr = syscall_ptr
        tempvar range_check_ptr = range_check_ptr
    else:
    tempvar syscall_ptr = syscall_ptr
    tempvar range_check_ptr = range_check_ptr
    end
    
    let (success2_) = IERC20.approve(contract_address = _asset, spender = _target, amount = _amount)  
    with_attr error_message("__approveAssetSpender: Approve didn't succeed"):
            assert_not_zero(success2_)
    end
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