%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_not_equal,
)
from starkware.cairo.common.bool import (
    TRUE,
    FALSE,
)

from magnety.persistant.vault.utils.shareBaseToken import (
    #getters
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

    #externals
    _setName
    _setSymbol
    initializer
    approve
    setApprovalForAll
    safeTransferFrom
    mint
    burn
    subShares
)

#
# Events
#

@event
func ComptrolleurSet(prevComptrolleur: felt, nextComptrolleur: felt):
end

@event
func MigratorSet(prevMigrator: felt, nextMigrator: felt):
end

@event
func OwnerSet(prevComptrolleur: felt, nextComptrolleur: felt):
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
func creator() -> (creatorAddress: felt):
end

@storage_var
func trackedAssets() -> (trackedAssetsAddress: felt*):
end

@storage_var
func assetToIsTracked(assetsAddress: felt) -> (isTracked: felt):
end

@storage_var
func accountToIsAssetManager(accountAddress: felt) -> (isAssetManager: felt):
end

@storage_var
func externalPositionToIsActive(externalPositionAddress: felt) -> (isActive: felt):
end

@storage_var
func activeExternalPositions() -> (activeExternalPositionsAddress: felt*):
end

@storage_var
func nominatedOwner() -> (nominatedOwnerAddress: felt):
end


#
# Getters
#

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

func init{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(
        _owner: felt,
        _comptrolleur: felt,
        _fundName: felt,
        _symbol: felt,
    ):

    let _creator = creator.read()
    with_attr error_message("init: Proxy already initialized"):
        assert creator == 0
    end

    let (caller) = get_caller_address()
    creator.write(caller)

    __setComptrolleur(_comptrolleur)
    __setOwner(_owner)
    initialize(_fundName, _symbol, _comptrolleur)

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
        _nextComptrolleur: felt, 
    ):
    with_attr error_message("setComptrolleur: cannot set the comptrolleur to the zero address"):
        assert_not_zero(_nextComptrolleur)
    end
    let (prevComptrolleur: felt) = comptrolleur.read()
    comptrolleur.write(_nextComptrolleur)
    ComptrolleurSet.emit(prevComptrolleur, _nextComptrolleur)
    return ()
end

func __setOwner{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _nextOwner: felt, 
    ):
    with_attr error_message("setComptrolleur: cannot set the owner to the zero address"):
        assert_not_zero(_nextOwner)
    end

    let (prevOwner: felt) = owner.read()

    with_attr error_message("setComptrolleur: the next owner address is the current owner address"):
        assert_not_equal(prevOwner, _nextOwner)
    end   

    owner.write(_nextOwner)
    Owner.emit(prevOwner, _nextOwner)
    return ()
end

func __setVaultLib{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _nextVaultLib: felt, 
    ):
    with_attr error_message("setVaultLib: cannot set the vaultlib to the zero address"):
        assert_not_zero(_nextVaultLib) 
    end

    let (_creator: felt) = creator.read()

    with_attr error_message("setVaultLib: Not allowded caller"):
        assert _nextVaultLib - _creator == 0
    end


    let (prevVaultLib: felt) = vaultLib.read()
    vaultLib.write(_nextVaultLib)
    VaultLibSet.emit(prevVaultLib, _nextVaultLib)
    return ()
end

func __setMigrator{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _nextMigratorAddress: felt, 
    ):
    with_attr error_message("__setMigrator: cannot set the migrator to the zero address"):
        assert_not_zero(_nextMigratorAddress) 
    end

    let (previousMigrator: felt) = migrator.read()

    with_attr error_message("setVaultLib: Not allowded caller"):
        assert_not_equal(_nextMigratorAddress, previousMigrator)
    end

    migrator.write(_nextMigratorAddress)
    MigratorSet.emit(previousMigrator, _nextMigratorAddress)
    return ()
end

