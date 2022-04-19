%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import (
    assert_not_zero,
)


from starkware.cairo.common.uint256 import Uint256, uint256_check



#
# Storage
#

@storage_var
func comptrollerProxyToVaultProxy(comptrollerProxyAddress:felt) -> (vaultProxyAddress: felt):
end

@storage_var
func vaultFactory() -> (vaultFactoryAddress: felt):
end

#
# Event
#

@event
func ValidatedVaultProxySetForFund(_comptrollerProxy, _vaultProxy):
end


#
# Initializer
#

func extensionBaseInitializer{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(
        _vaultFactory: felt,
    ):
    vaultFactory.write(_vaultFactory)
    return ()
end

#
# Modifier
#

func onlyvaultFactory{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }():

    let(vaultFactory_) = vaultFactory.read()
    let(caller_) = get_caller_address()

    with_attr error_message("onlyvaultFactory: only callable by the vaultFactory"):
       assert (vaultFactory_ - caller_) = 0
    end
    return ()
end


#
# Internal
#

func __setValidatedVaultProxy{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _comptrollerProxy: felt, 
        _vaultProxy: felt,
    ):
    comptrollerProxyToVaultProxy.write(_comptrollerProxy,_vaultProxy)
    ValidatedVaultProxySetForFund.emit(_comptrollerProxy, _vaultProxy)
    return ()
end


