%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.memcpy import memcpy

from IComptrolleur import IComptrolleur
from IVault import (
    VaultAction
)
from starkware.cairo.common.alloc import (
    alloc,
)


#
# Internal
#

func __addExternalPosition{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        _externalPosition: felt,
    ):
    alloc_locals
    let (local calldata_ : felt*) = alloc()
    assert [calldata_] = _externalPosition
    let vaultAction_:felt = VaultAction.AddExternalPosition
    IComptrolleur.permissionedVaultAction(contract_address= _comptrollerProxy, vaultAction= vaultAction_,calldata_len=1, calldata=calldata_)
    return ()
end

func __addTrackedAsset{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        _asset: felt,
    ):
    alloc_locals
    let (local calldata_ : felt*) = alloc()
    assert [calldata_] = _asset
    let vaultAction_:felt = VaultAction.AddTrackedAsset
    IComptrolleur.permissionedVaultAction(contract_address= _comptrollerProxy, vaultAction= vaultAction_,calldata_len=1, calldata=calldata_)
    return ()
end


func __approveAssetSpender{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        _asset: felt,
        _target: felt,
        _amount: felt,
    ):
    alloc_locals
    let (local calldata_ : felt*) = alloc()
    assert [calldata_] = _asset
    assert [calldata_+1] = _target
    assert [calldata_+2] = _amount
    let vaultAction_:felt = VaultAction.ApproveAssetSpender
    IComptrolleur.permissionedVaultAction(contract_address= _comptrollerProxy, vaultAction= vaultAction_,calldata_len=3, calldata=calldata_)
    return ()
end




func __burnShares{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        _tokenId: felt,
        _amount: felt,
    ):
    alloc_locals
    let (local calldata_ : felt*) = alloc()
    assert [calldata_] = _tokenId
    assert [calldata_+1] = _amount
    let vaultAction_:felt = VaultAction.BurnShares
    IComptrolleur.permissionedVaultAction(contract_address= _comptrollerProxy, vaultAction= vaultAction_,calldata_len=2, calldata=calldata_)
    return ()
end




func __callOnExternalPosition{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        _externalPosition: felt,
        _callOnExternalPositionActionData_len:felt,
        _callOnExternalPositionActionData:felt*,
        _assetsToTransfer_len:felt,
        _assetsToTransfer:felt*,
        _amountsToTransfer:felt*,
        _assetsToReceive_len:felt,
        _assetsToReceive:felt*,
    ):
    alloc_locals
    let (local calldata_ : felt*) = alloc()
    assert [calldata_] = _externalPosition
    assert [calldata_+1] = _callOnExternalPositionActionData_len
    memcpy(calldata_+2, _callOnExternalPositionActionData, _callOnExternalPositionActionData_len)
    assert [calldata_+2+_callOnExternalPositionActionData_len] = _assetsToTransfer_len
    memcpy(calldata_+2+_callOnExternalPositionActionData_len+1, _assetsToTransfer, _assetsToTransfer_len)
    memcpy(calldata_+2+_callOnExternalPositionActionData_len+1+_assetsToTransfer_len, _amountsToTransfer, _assetsToTransfer_len)
    assert [calldata_+2+_callOnExternalPositionActionData_len+1+2*_assetsToTransfer_len] = _assetsToReceive_len
    memcpy(calldata_+2+_callOnExternalPositionActionData_len+1+2*_assetsToTransfer_len+1, _assetsToReceive, _assetsToReceive_len)
    let vaultAction_:felt = VaultAction.CallOnExternalPosition
    IComptrolleur.permissionedVaultAction(contract_address= _comptrollerProxy, vaultAction= vaultAction_,calldata_len= 2+_callOnExternalPositionActionData_len+1+2*_assetsToTransfer_len+1+_assetsToReceive_len, calldata=calldata_)
    return ()
end
    



func __mintShares{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        _newSharesholder: felt,
        _amount:felt,
        _sharePricePurchased:felt,
    ):
    alloc_locals
    let (local calldata_ : felt*) = alloc()
    assert [calldata_] = _newSharesholder
    assert [calldata_+1] = _amount
    assert [calldata_+2] = _sharePricePurchased
    let vaultAction_:felt = VaultAction.MintShares
    IComptrolleur.permissionedVaultAction(contract_address= _comptrollerProxy, vaultAction= vaultAction_,calldata_len=3, calldata=calldata_)
    return ()
end


func __removeExternalPosition{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        _externalPosition: felt,
    ):
    alloc_locals
    let (local calldata_ : felt*) = alloc()
    assert [calldata_] = _externalPosition
    let vaultAction_:felt = VaultAction.RemoveExternalPosition
    IComptrolleur.permissionedVaultAction(contract_address= _comptrollerProxy, vaultAction= vaultAction_,calldata_len=1, calldata=calldata_)
    return ()
end




func __removeTrackedAsset{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        _asset: felt,
    ):
    alloc_locals
    let (local calldata_ : felt*) = alloc()
    assert [calldata_] = _asset
    let vaultAction_:felt = VaultAction.RemoveTrackedAsset
    IComptrolleur.permissionedVaultAction(contract_address= _comptrollerProxy, vaultAction= vaultAction_,calldata_len=1, calldata=calldata_)
    return ()
end




func __transferShares{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        from_: felt,
        to_: felt,
        tokenId_: felt,
    ):
    alloc_locals
    let (local calldata_ : felt*) = alloc()
    assert [calldata_] = from_
    assert [calldata_+1] = to_
    assert [calldata_+2] = tokenId_
    let vaultAction_:felt = VaultAction.TransferShares
    IComptrolleur.permissionedVaultAction(contract_address= _comptrollerProxy, vaultAction= vaultAction_,calldata_len=3, calldata=calldata_)
    return ()
end




func __withdrawAssetTo{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        asset_: felt,
        target_: felt,
        amount_: felt,
    ):
    alloc_locals
    let (local calldata_ : felt*) = alloc()
    assert [calldata_] = asset_
    assert [calldata_+1] = target_
    assert [calldata_+2] = amount_
    let vaultAction_:felt = VaultAction.WithdrawAssetTo
    IComptrolleur.permissionedVaultAction(contract_address= _comptrollerProxy, vaultAction= vaultAction_,calldata_len=3, calldata=calldata_)
    return ()
end




