%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import (
    assert_not_zero,
)


from starkware.cairo.common.uint256 import Uint256, uint256_check


#
# Events
#

@event
func CallOnIntegrationExecutedForFund(
    comptrollerProxy: felt, 
    caller:felt, 
    protocol:felt, 
    selector:felt, 
    integrationData:felt*, 
    incomingAssetsLength:felt, 
    incomingAssets:felt*,
    incomingAssetAmounts:Uint256*,
    spendAssetsLength:felt,
    spendAssets:felt*,
    spendAssetsAmounts:Uint256*,
):
end


#
# Storage
#

@storage_var
func policyManager() -> (policyManagerAddress: felt):
end

@storage_var
func valueInterpreter() -> (valueInterpreterAddress: felt):
end

@constructor
func constructor{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(
        _valueInterpreter: felt,
        _policyManager: felt,
    ):
    policyManager.write(_policyManager)
    valueInterpreter.write(_policyManager)
    return ()
end



#
# Externals
#

func setConfigForFund{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        _vaultProxy: felt,
    ):

    onlyMigrator()

    with_attr error_message("setVaultLib: cannot set the vaultlib to the zero address"):
        assert_not_zero(_nextVaultLib) 
    end

    let (prevVaultLib: felt) = vaultLib.read()
    vaultLib.write(_nextVaultLib)
    VaultLibSet.emit(prevVaultLib, _nextVaultLib)
    return ()
end


#
# Internal
#

func __setComptrolleur{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrolleur: felt, 
    ):
    with_attr error_message("setComptrolleur: cannot set the comptrolleur to the zero address"):
        assert_not_zero(_comptrolleur)
    end
    comptrolleur.write(_comptrolleur)
    ComptrolleurSet.emit(_comptrolleur)
    return ()
end


func __setOwner{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _owner: felt, 
    ):
    with_attr error_message("_setOwner: cannot set the owner to the zero address"):
        assert_not_zero(_owner) 
    end


    owner.write(_owner)
    OwnerSet.emit(_owner)
    return ()
end

