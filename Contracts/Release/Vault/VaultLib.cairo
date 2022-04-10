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