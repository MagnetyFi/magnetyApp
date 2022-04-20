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
func ComptrolleurSet(Comptrolleur: felt):
end






#
# Storage
#

@storage_var
func comptrolleur() -> (comptrolleurAddress: felt):
end


@storage_var
func trackedAssets(id: felt) -> (trackedAssetsAddress: felt):
end

@storage_var
func assetToId(asset: felt) -> (id: felt):
end

@storage_var
func trackedAssetsLength() -> (length: felt):
end

@storage_var
func assetToIsTracked(assetsAddress: felt) -> (isTracked: felt):
end

@storage_var
func positionLimit() -> (positionLimitAmount: Uint256):
end


#
# Constructor
#

func init{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(
        _comptrolleur: felt,
        _positionLimitAmount:Uint256,
    ):
    __setComptrolleur(_comptrolleur)
    uint256_check(_positionLimitAmount)
    positionLimit.write(_positionLimitAmount)
    return ()
end

#
# Modifiers
#

func onlyVaultComptrolleur{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }():
    let(comptrolleur_) = comptrolleur.read()
    let(caller_) = get_caller_address()

    with_attr error_message("onlyVaultComptrolleur: only callable by the comptrolleur"):
       assert (comptrolleur_ - caller_) = 0
    end
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

