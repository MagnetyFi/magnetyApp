%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_not_equal,
)

from openzeppelin.token.erc20.interfaces.IERC20 import (
    balanceOf,
    allowance,
    transfer,
    transferFrom,
    approve,
)

from starkware.cairo.common.find_element import (
    find_element,
)

from starkware.cairo.common.bool import (
    TRUE,
    FALSE,
)

from magnety.persistant.vault.vaultLibBaseCore import (

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

    #NFT Shares externals
    _setName
    _setSymbol
    approve
    setApprovalForAll
    safeTransferFrom
    mint
    burn
    subShares

    #init
    init

    #basic storage
    comptrolleur,
    migrator,
    owner,
    vaultLib,
    creator,
    trackedAssets,
    assetToIsTracked,
    accountToIsAssetManager,
    externalPositionToIsActive,
    activeExternalPositions,
    nominatedOwner,
    

    __setComptrolleur
    __setMigrator
    __setOwner
    __setVaultLib
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

#
# Storage
#

@storage_var
func externalPositionManager() -> (externalPositionManagerAddress: felt):
end

@storage_var
func positionLimit() -> (positionLimitAmount: Uint256):
end

@storage_var
func trackedAssetsLength() -> (length: felt):
end

@storage_var
func activeExternalPositionsLength() -> (length: Uint256):
end


#
# Getters
#


func isAssetManager{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(who: felt) -> (isAssetManager_: felt):
    let (isAssetManager_:felt) = accountToIsAssetManager.read(who)
    return FALSE if isAssetManager_ == 0 else TRUE
end

func isTrackedAsset{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_asset: felt) -> (isTrackedAsset_: felt):
    let (isTrackedAsset_:felt) = assetToIsTracked.read(_asset)
    return FALSE if isTrackedAsset_ == 0 else TRUE
end

func isActiveExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_externalPosition: felt) -> (isActiveExternalPosition_: felt):
    let (isActiveExternalPosition_:felt) = externalPositionToIsActive.read(_externalPosition)
    return FALSE if isActiveExternalPosition_ == 0 else TRUE
end

func getOwner{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (owner_: felt):
    let (owner_:felt) = owner.read()
    return owner
end

# CALL migration manager to get the funddeployer for this proxy
func getFundDeployer{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (fundDeployer_: felt):
    

    return fundDeployer_
end

func getExternalPositionManager{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (externalPositionManager_: felt):
    let (externalPositionManager_:felt) = externalPositionManager.read()
    return externalPositionManager_
end

func getPositionsLimit{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (positionLimit_: Uint256):
    let (positionLimit_:Uint256) = positionLimit.read()
    return positionLimit_
end

func getAssetBalance{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_asset: felt) -> (assetBalance_: Uint256):
    let (assetBalance_:Uint256) = IERC20.balanceOf(contract_address=_asset)
    return assetBalance_
end



#
# Constructor
#
@constructor
func vaultLibInitializer{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        _fundName: felt,
        _symbol: felt,
        _comptrolleur: felt,
        _owner: felt,
        _externalPositionManager: felt,
        _positionLimitAmount: Uint256,
    ):
    init(_owner, _comptrolleur, _fundName, _symbol);
    externalPositionManager.write(_externalPositionManager)
    uint256_check(_positionLimitAmount)
    positionLimitAmount.write(_positionLimitAmount)
    return ()
end

#
# modifier
#

func onlyVaultComptrolleur{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }():
    let(_comptrolleur) = comptrolleur.read()
    let(_caller) = get_caller_address()

    with_attr error_message("onlyVaultOwner: only callable by the VaultOwner"):
       assert (_comptrolleur() - _caller) == 0
    end
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
    let (isregistred: felt) = isAssetManager(_manager)
    with_attr error_message("addAssetManager: asset manager already registred"):
        assert isregistred == 0
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
        assert _nextOwner - nextOwner == 0
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

func setMigrator{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(_nextMigrator: felt):
    onlyVaultComptrolleur()
    __setMigrator(_nextMigrator)
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
        assert _currentOwner - currentOwner == 0
    end

    let (removedNominatedOwner:felt) = nominatedOwner.read()

    with_attr error_message("removeNominatedOwner: There is no nominated owner"):
        assert_not_zero(removedNominatedOwner)
    end

    nominatedOwner.write(0)

    NominatedOwnerRemoved.emit(removedNominatedOwner)
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
    let (isregistred: felt) = isAssetManager(_manager)
    with_attr error_message("addAssetManager: asset manager not registred"):
        assert isregistred == 1
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
        _tokenId:felt,
    ):
    let(_comptrolleur:felt) = comptrolleur.read()
    let(_caller:felt) = get_caller_address()
    let(_shareowner:felt)  = ownerOf(_tokenId)

    with_attr error_message("burnShares: approve caller is not owner nor approved for all"):
        assert (_comptrolleur - _caller) * (_shareowner - _caller) == 0
    end

    let(_sharesAmount:felt) = sharesBalance(_tokenId)

    if _sharesAmount == _amount:
        burn(token_id)
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
   mint(_newSharesholder, _tokenId, _amount, _sharePricePurchased)
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
end






#
# internal
#


## see array manipulation
# func __addTrackedAsset{
#         syscall_ptr: felt*,
#         pedersen_ptr: HashBuiltin*,
#         range_check_ptr
#     }(_asset: felt) -> (externalPositionManager_: felt):

#     let (isTrackedAsset_:felt) = isTrackedAsset(_asset)
#     with_attr error_message("__addTrackedAsset: asset already tracked"):
#         assert isTrackedAsset_ == FALSE
#     end
#     __validatePositionsLimit()

#     assetToIsTracked.write(_asset,TRUE)
#     let (currentTrackedAssetsLength:felt) = trackedAssetsLength.read() 
#     alloc_locals
#     let(trackedAssets_:felt*) = trackedAssets.read()
#     trackedAssets_[currentTrackedAssetsLength] = _asset
#     trackedAssets.write(trackedAssets_)
#     let (newTrackedAssetsLength:felt) = uint256_checked_add(currentTrackedAssetsLength, Uint256(1,0))
#     trackedAssetsLength.write(newTrackedAssetsLength)
#     TrackedAssetAdded.emit(_asset)
# end

# func __removeTrackedAsset{
#         syscall_ptr: felt*,
#         pedersen_ptr: HashBuiltin*,
#         range_check_ptr
#     }(_asset: felt) -> (externalPositionManager_: felt):

#     let (isTrackedAsset_:felt) = isTrackedAsset(_asset)
#     with_attr error_message("__removeTrackedAsset: asset not tracked"):
#         assert isTrackedAsset_ == TRUE
#     end

#     assetToIsTracked.write(_asset,TRUE)
#     let (currentTrackedAssetsLength:felt) = trackedAssetsLength.read() 
#     alloc_locals
#     let(trackedAssets_:felt*) = trackedAssets.read()
#     trackedAssets_[currentTrackedAssetsLength] = _asset
#     trackedAssets.write(trackedAssets_)
#     let (newTrackedAssetsLength:felt) = uint256_checked_add(currentTrackedAssetsLength, Uint256(1,0))
#     trackedAssetsLength.write(newTrackedAssetsLength)
#     TrackedAssetRemoved.emit(_asset)
# end

# func __addExternalPosition{
#         syscall_ptr: felt*,
#         pedersen_ptr: HashBuiltin*,
#         range_check_ptr
#     }(_externalPosition: felt):
#     let (isActiveExternalPosition_:felt) = isActiveExternalPosition(_externalPosition)

#     with_attr error_message("__addExternalPosition: externalPosition already active"):
#         assert isActiveExternalPosition_ == FALSE
#     end
#     __validatePositionsLimit()

#     externalPositionToIsActive.write(_externalPosition,TRUE)
#     let (currentActiveExternalPositionsLength:felt) = activeExternalPositionsLength.read() 
#     alloc_locals
#     let(activeExternalPositions_:felt*) = activeExternalPositions.read()
#     activeExternalPositions_[currentActiveExternalPositionsLength] = _externalPosition
#     activeExternalPositions.write(activeExternalPositions_)
#     let (newActiveExternalPositionsLength:felt) = uint256_checked_add(currentActiveExternalPositionsLength, Uint256(1,0))
#     activeExternalPositionsLength.write(newActiveExternalPositionsLength)
#     ExternalPositionAdded.emit(_asset)
# end

# func __removeExternalPosition{
#         syscall_ptr: felt*,
#         pedersen_ptr: HashBuiltin*,
#         range_check_ptr
#     }(_externalPosition: felt):
#     let (isActiveExternalPosition_:felt) = isActiveExternalPosition(_externalPosition)

#     with_attr error_message("__removeExternalPosition: externalPosition not active"):
#         assert isActiveExternalPosition_ == TRUE
#     end

#     externalPositionToIsActive.write(_externalPosition,TRUE)
#     let (currentActiveExternalPositionsLength:felt) = activeExternalPositionsLength.read() 
#     alloc_locals
#     let(activeExternalPositions_:felt*) = activeExternalPositions.read()
#     activeExternalPositions_[currentActiveExternalPositionsLength] = _externalPosition
#     activeExternalPositions.write(activeExternalPositions_)
#     let (newActiveExternalPositionsLength:felt) = uint256_checked_add(currentActiveExternalPositionsLength, Uint256(1,0))
#     activeExternalPositionsLength.write(newActiveExternalPositionsLength)
#     ExternalPositionRemoved.emit(_externalPosition)
# end



func __approveAssetSpender{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
    _asset: felt,
    _target: felt,
    _amount: Uint256,
    )

end


func __validatePositionsLimit{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }():

    let (positionLimit_:Uint256) = getPositionsLimit()
    let (trackedAssetsLength_:Uint256) = trackedAssetsLength.read()
    let (activeExternalPositionsLength_:Uint256) = activeExternalPositionsLength.read()
    with_attr error_message("__validatePositionsLimit: Limit exceeded"):
        assert_le(trackedAssetsLength_ + activeExternalPositionsLength_, positionLimit_)
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
    let (_success:felt) = IERC20(_asset).transfer(_target, _amount)
    with_attr error_message("__withdrawAssetTo: transfer didn't work"):
        assert_not_zero(_success)
    end

    AssetWithdrawn.emit(_asset, _target, _amount)
    return ()
end