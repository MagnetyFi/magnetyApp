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

@event
func MigratorSet(Migrator: felt):
end

@event
func OwnerSet(Owner: felt):
end

@event
func VaultLibSet(prevVaultLib: felt, nextVaultLib: felt):
end



#
# Storage
#

@storage_var
func comptrolleur() -> (comptrolleurAddress: felt):
end

@storage_var
func migrator() -> (migratorAddress: felt):
end

@storage_var
func owner() -> (ownerAddress: felt):
end

@storage_var
func vaultLib() -> (vaultLibAddress: felt):
end

@storage_var
func vaultFactory() -> (vaultFactoryAddress: felt):
end





@storage_var
func trackedAssets(id: Uint256) -> (trackedAssetsAddress: felt):
end

@storage_var
func activeExternalPositions(id: Uint256) -> (activeExternalPositionsAddress: felt):
end

@storage_var
func trackedAssetsLength() -> (length: Uint256):
end

@storage_var
func activeExternalPositionsLength() -> (length: Uint256):
end

@storage_var
func assetToIsTracked(assetsAddress: felt) -> (isTracked: felt):
end

@storage_var
func externalPositionToIsActive(externalPositionAddress: felt) -> (isActive: felt):
end

@storage_var
func accountToIsAssetManager(accountAddress: felt) -> (isAssetManager: felt):
end

@storage_var
func nominatedOwner() -> (nominatedOwnerAddress: felt):
end

@storage_var
func externalPositionManager() -> (externalPositionManagerAddress: felt):
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
        _owner: felt,
        _comptrolleur: felt,
        _vaultLib: felt,
        _externalPositionManager: felt,
        _positionLimitAmount:Uint256,
    ):

    let (migrator_:felt) = migrator.read()

    with_attr error_message("init: Proxy already initialized"):
        assert migrator_ = 0
    end

    let (caller) = get_caller_address()

    migrator.write(caller)
    MigratorSet.emit(caller)


    __setComptrolleur(_comptrolleur)
    __setOwner(_owner)

    setVaultLib(_vaultLib)
    externalPositionManager.write(_externalPositionManager)
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

func onlyMigrator{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }():
    let(migrator_) = migrator.read()
    let(caller_) = get_caller_address()

    with_attr error_message("onlyMigrator: only callable by the migrator"):
       assert (migrator_ - caller_) = 0
    end
    return ()
end



#
# Externals
#

func setVaultLib{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _nextVaultLib: felt, 
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

