%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address


from magnety.persistant.vault.utils.shareBaseToken import (

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

    initializer
    approve
    setApprovalForAll
    safeTransferFrom
    mint
    burn
    subShares
)