%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address,
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_not_equal,
)

from starkware.cairo.common.memcpy import memcpy

from openzeppelin.token.erc20.interfaces.IERC20 import (
    balanceOf,
    allowance,
    transfer,
    transferFrom,
    approve,
)
from warp.src.warp.cairo-src.evm.utils import (
    felt_to_uint256,
)

from starkware.cairo.common.find_element import (
    find_element,
)

from starkware.cairo.common.bool import (
    TRUE,
    FALSE,
)

from starkware.cairo.common.uint256 import (
    Uint256, 
    uint256_check,
    uint256_signed_lt
)

from IVault import (
    VaultAction
)

from IExternalPosition import (
    receiveCallFromVault
)



from magnety.persistant.vault.utils.shareBaseToken import (

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

    _setName
    _setSymbol
    approve
    setApprovalForAll
    transferSharesFrom
    mint
    burn
    subShares

    #init
    initializeShares
)

from magnety.persistant.vault.vaultLibBaseCore import (

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
    assetToId 
    externalPositionToId

    positionLimit,

    accountToIsAssetManager,
    nominatedOwner,

    init
    onlyVaultComptrolleur
    onlyMigrator
    setVaultLib
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

@view
func getVaultLib{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (vaultLib: felt):
    let (vaultLib: felt) = vaultLib.read()
    return (vaultLib)
end

@view
func getComptrolleur{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (comptrolleur: felt):
    let (comptrolleur: felt) = comptrolleur.read()
    return (comptrolleur)
end

@view
func getVaultFactory{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (vaultFactory: felt):
    let (vaultFactory: felt) = vaultFactory.read()
    return (vaultFactory)
end

@view
func getOwner{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (owner: felt):
    let (owner: felt) = owner.read()
    return (owner)
end

@view
func getMigrator{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (migrator: felt):
    let (migrator: felt) = migrator.read()
    return (migrator)
end



@view
func canMigrate{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(who: felt) -> (canMigrate: felt):
    let (owner: felt) = owner.read()
    let (migrator: felt) = migrator.read()
    let (isAllowed: felt) = (who - owner) * (who - migrator)
    return TRUE if isAllowed == 0 else FALSE
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
        _vaultLib: felt,
        _externalPositionManager: felt,
        _positionLimitAmount: Uint256,
    ):
    initializeShares(_fundName, _symbol)
    init(_owner, _comptrolleur, _vaultLib, _externalPositionManager, _positionLimitAmount);
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

func callOnContract{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _contract:felt,
        
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

func receiveValidatedVaultAction{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _action: VaultAction,
        _actionData:felt*,
        _actionDataLength:felt,
    ):
    onlyVaultComptrolleur()
    if _action == VaultAction.AddExternalPosition :
         __executeVaultActionAddExternalPosition(_actionData);
    end
    else if _action == VaultAction.AddTrackedAsset : 
         __executeVaultActionAddTrackedAsset(_actionData);
    end
    else if _action == VaultAction.ApproveAssetSpender:
        __executeVaultActionApproveAssetSpender(_actionData);
    end
    else if _action == VaultAction.BurnShares:
        __executeVaultActionBurnShares(_actionData);
    end
    else if _action == VaultAction.CallOnExternalPosition:
        __executeVaultActionCallOnExternalPosition(_actionData);
    end
    else if _action == VaultAction.MintShares:
        __executeVaultActionMintShares(_actionData);
    end
    else if _action == VaultAction.RemoveExternalPosition:
        __executeVaultActionRemoveExternalPosition(_actionData);
    end
    else if action == VaultAction.RemoveTrackedAsset:
        __executeVaultActionRemoveTrackedAsset(_actionData);
    end
    else if action == VaultAction.TransferShares:
        __executeVaultActionTransferShares(_actionData);
    end
    else if action == VaultAction.WithdrawAssetTo:
        __executeVaultActionWithdrawAssetTo(_actionData);
    end

end




#
# VAULT ACTION DISPATCH
#

func __executeVaultActionAddExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (address_:felt) = _actionData[0]
    __addExternalPosition(address_)
end

func __executeVaultActionAddTrackedAsset{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (address_:felt) = _actionData[0]
    __addTrackedAsset(address_)
end

func __executeVaultActionApproveAssetSpender{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (address_:felt) = _actionData[0]
    let (target_:felt) = _actionData[1]
    let (amount_:Uint256) = felt_to_uint256_(actionData[2])
    __approveAssetSpender(address_, target_, amount_)
end

func __executeVaultActionBurnShares{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (tokenId_:felt) = _actionData[0]
    let (amount_:Uint256) = felt_to_uint256_(_actionData[1])
    burnShares(amount_, tokenId_)
end

func __executeVaultActionCallOnExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (externalPosition_:felt) = _actionData[0]
    #CallOnExternalPositionActionData
    let (callOnExternalPositionActionDataLength_:felt) = (_actionData[1])
    let (local callOnExternalPositionActionData_ : felt*) = alloc()
    memcpy(callOnExternalPositionActionData_, _actionData + 2, callOnExternalPositionActionDataLength_)
    #AssetToTransfer
    let (currentIndex_:felt) = 2 + callOnExternalPositionActionDataLength_
    let (assetsToTransferLength_:felt) = _actionData[currentIndex_]
    let (local assetsToTransfer_: felt*) = alloc()
    memcpy(assetsToTransfer_, _actionData + currentIndex_ + 1, assetsToTransferLength_)
    let (local amountsToTransferFelt_: felt*) = alloc()
    memcpy(amountsToTransferFelt_, _actionData + currentIndex_ + 1 + assetsToTransferLength_, assetsToTransferLength_)
    let (local amountsToTransfer_: felt*) = alloc()
    __memcpyUint256(amountsToTransfer_, amountsToTransferFelt_, assetsToTransferLength_)
    let (local assetsToReceive_: felt*) = alloc()
    let (currentIndex2_: felt) = _actionData + currentIndex_ + 1 + 2*assetsToTransferLength_
    let (assetsToReceiveLength_: felt) = _actionData[currentIndex2_]
    memcpy(assetsToReceive_, currentIndex2_ + 1, assetsToReceiveLength_)

    __callOnExternalPosition(
        externalPosition_,
        callOnExternalPositionActionDataLength_,
        callOnExternalPositionActionData_,
        assetsToTransferLength_,
        assetsToTransfer_,
        amountsToTransfer_,
        assetsToReceiveLength_,
        assetsToReceive_)
end

# same as memcpy but to copy and transform to Uint256
func __memcpyUint256{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(dst: Uint256*, src: felt*, len: felt):
    struct LoopFrame:
        member dst : felt*
        member src : felt*
    end

    if len == 0:
        return ()
    end

    %{ vm_enter_scope({'n': ids.len}) %}
    tempvar frame = LoopFrame(dst=dst, src=src)

    loop:
    let frame = [cast(ap - LoopFrame.SIZE, LoopFrame*)]
    assert [frame.dst] = felt_to_uint256([frame.src])

    let continue_copying = [ap]
    # Reserve space for continue_copying.
    let next_frame = cast(ap + 1, LoopFrame*)
    next_frame.dst = frame.dst + 1; ap++
    next_frame.src = frame.src + 1; ap++
    %{
        n -= 1
        ids.continue_copying = 1 if n > 0 else 0
    %}
    static_assert next_frame + LoopFrame.SIZE == ap + 1
    jmp loop if continue_copying != 0; ap++
    # Assert that the loop executed len times.
    len = cast(next_frame.src, felt) - cast(src, felt)

    %{ vm_exit_scope() %}
    return ()
end

func __executeVaultActionMintShares{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (newSharesholder_:felt) = _actionData[0]
    let (amount_:Uint256) = felt_to_uint256_(_actionData[1])
    let (sharePricePurchased_:Uint256) = felt_to_uint256_(_actionData[2])
    mintShares(amount_, newSharesholder_, sharePricePurchased_)
end

func __executeVaultActionRemoveExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (address_:felt) = _actionData[0]
    __removeExternalPosition(address_)
end

func __executeVaultActionRemoveTrackedAsset{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (address_:felt) = _actionData[0]
    __removeTrackedAsset(address_)
end

func __executeVaultActionTransferShares{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (from_:felt) = _actionData[0]
    let (to_:felt) = _actionData[1]
    let (tokenId_:Uint256) = felt_to_uint256_(_actionData[2])
    transferSharesFrom(_from, _to, _tokenId)
end

func __executeVaultActionWithdrawAssetTo{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_actionData: felt*):
    let (asset_:felt) = _actionData[0]
    let (target_:felt) = _actionData[1]
    let (amount_:Uint256) = felt_to_uint256_(_actionData[2])
    __withdrawAssetTo(asset_, target_, amount_)
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
        assert isTrackedAsset_ == FALSE
    end
    __validatePositionsLimit()
    let (currentTrackedAssetsLength: Uint256) = trackedAssetsLength.read()
    assetToIsTracked.write(_asset,TRUE)
    trackedAssets.write(currentTrackedAssetsLength,_asset)
    assetToId.write(_asset,currentTrackedAssetsLength)
    let (newTrackedAssetsLength_: Uint256) = uint256_checked_add(currentTrackedAssetsLength,Uint256(1,0))
    trackedAssetsLength.write(newTrackedAssetsLength_)
    TrackedAssetAdded.emit(_asset)
end

func __removeTrackedAsset{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_asset: felt):

    let (isTrackedAsset_:felt) = isTrackedAsset(_asset)
    with_attr error_message("__removeTrackedAsset: asset not tracked"):
        assert isTrackedAsset_ == TRUE
    end
    assetToIsTracked.write(_asset,FALSE)
    let (currentTrackedAssetsLength_: Uint256) = trackedAssetsLength.read()
    let (id:Uint256) = assetToId.read(_asset)
    let (res:Uint256) = uint256_checked_sub_le(currentTrackedAssetsLength_, id)
    let (newTrackedAssetsLength_: Uint256) = uint256_checked_sub_le(currentTrackedAssetsLength_,Uint256(1,0))
    if res == 1 : 
    trackedAssets.write(id, 0)
    end
    else :
    let (lastAssetId:Uint256) = newTrackedAssetsLength_
    let (lastAsset:felt) = trackedAssets.read(lastAssetId)
    trackedAssets.write(lastAssetId, 0)
    trackedAssets.write(id, lastAsset)
    assetToId(lastAsset).write(id)
    end
    trackedAssetsLength.write(newTrackedAssetsLength_)
    TrackedAssetRemoved.emit(_asset)
end

func __addExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_externalPosition: felt):

    let (isActiveExternalPosition_:felt) = isActiveExternalPosition(_externalPosition)
    with_attr error_message("_addExternalPosition: externalPosition already active":
        assert isActiveExternalPosition_ == FALSE
    end
    __validatePositionsLimit()
    let (currentActiveExternalPositionsLength_: Uint256) = activeExternalPositionsLength.read()
    isActiveExternalPosition.write(_externalPosition,TRUE)
    activeExternalPositions.write(currentActiveExternalPositionsLength_, _externalPosition)
    externalPositionToId.write(_externalPosition,currentActiveExternalPositionsLength_)
    let (newActiveExternalPositionsLength_: Uint256) = uint256_checked_add(currentActiveExternalPositionsLength_,Uint256(1,0))
    activeExternalPositionsLength.write(newActiveExternalPositionsLength_)
    ExternalPositionAdded.emit(_externalPosition)
end

func __removeExternalPosition{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_externalPosition: felt):
    let (isActiveExternalPosition_:felt) = isActiveExternalPosition(_externalPosition)

    with_attr error_message("__removeExternalPosition: externalPosition not active"):
        assert isActiveExternalPosition_ == TRUE
    end

    externalPositionToIsActive.write(_externalPosition,FALSE)

    let (currentActiveExternalPositionsLength_: Uint256) = activeExternalPositionsLength.read()
    let (id:Uint256) = externalPositionToId.read(_externalPosition)
    let (res:Uint256) = uint256_checked_sub_le(currentActiveExternalPositionsLength_, id)
    let (newActiveExternalPositionsLength_: Uint256) = uint256_checked_sub_le(currentTrackedAssetsLength,Uint256(1,0))
    if res == 1 : 
    activeExternalPositions.write(id, 0)
    end
    else :
    let (lastExternalPositionId:Uint256) = newActiveExternalPositionsLength_
    let (lastExternalPosition:felt) = activeExternalPositions.read(lastExternalPositionId)
    activeExternalPositions.write(lastExternalPositionId, 0)
    activeExternalPositions.write(id, lastAsset)
    externalPositionToId(lastExternalPosition).write(id)
    end
    activeExternalPositionsLength.write(newActiveExternalPositionsLength_)
    ExternalPositionRemoved.emit(_externalPosition)
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

    let (isActiveExternalPosition_:felt) = isActiveExternalPosition(_externalPosition)

    with_attr error_message("__callOnExternalPosition: externalPosition not active"):
        assert isActiveExternalPosition_ == TRUE
    end
    # transfer all asset +
    # track new asset to receive

    IExternalPosition.receiveCallFromVault(contract_address = _externalPosition, _actionData = _callOnExternalPositionActionData)
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

    let (vaultProxyAddress_: felt) = get_contract_address()
    let (allowanceAmount_ : Uint256) = IERC20.allowance(contract_address = _asset, ownner = vaultProxyAddress_, spender = _target)
    let (existingAllowance) = uint256_signed_lt(Uint256(0,0),allowanceAmount_)
    if existingAllowance == 1 :
        let (success_) = IERC20.approve(contract_address = _asset, spender = _target, amount = 0)  
        with_attr error_message("__approveAssetSpender: Approve didn't succeed"):
            assert_not_zero(succes_)
        end
    end
    let (succes_) = let (success) = IERC20.approve(contract_address = _asset, spender = _target, amount = _amount)  
    with_attr error_message("__approveAssetSpender: Approve didn't succeed"):
            assert_not_zero(succes_)
    end
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