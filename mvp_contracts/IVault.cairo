%lang starknet

from starkware.cairo.common.uint256 import Uint256

struct VaultAction:
    member BurnShares: felt
    member MintShares: felt
    member AddTrackedAsset: felt
    member RemoveTrackedAsset: felt
    member TransferShares: felt
    member WithdrawAssetTo: felt
end

@contract_interface
namespace IVault:
    #Vault actionn only call this with the right vaultAction to perform

    func receiveValidatedVaultAction(_action:Uint256, _actionData_len:felt, _actionData:Uint256):
    end



    #Vault getters

    func isTrackedAsset(_asset: felt) -> (isTrackedAsset_: Uint256):
    end

    func getTrackedAssets() -> (trackedAssets_len_: Uint256, trackedAssets_:felt*):
    end

    func getPositionsLimit() -> (positionLimit_: Uint256):
    end

    func getAssetBalance(_asset: felt) -> (assetBalance_: Uint256):
    end

    func getComptrolleur() -> (comptrolleurAd: felt):
    end


    #NFT getters

    func getName() -> (name: felt):
    end

    func getSymbol() -> (symbol: felt):
    end

    func getTotalSupply() -> (totalSupply: Uint256):
    end

    func getSharesTotalSupply() -> (sharesTotalSupply: Uint256):
    end

    func getSharesBalance(token_id: Uint256) -> (sharesBalance: Uint256):
    end

    func getBalanceOf(owner: felt) -> (balance: Uint256):
    end

    func getOwnerOf(tokenId: Uint256) -> (owner: felt):
    end

    func getSharePricePurchased(tokenId: Uint256) -> (sharePricePurchased: Uint256):
    end

    func getMintedBlock(tokenId: Uint256) -> (mintedBlock: felt):
    end

end