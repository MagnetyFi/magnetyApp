%lang starknet

from starkware.cairo.common.uint256 import Uint256

struct VaultAction:
    member BurnShares: felt
    member MintShares: felt
    member AddTrackedAsset: felt
    member RemoveTrackedAsset: felt
end

@contract_interface
namespace IVault:
    #Vault action

    func addTrackedAsset(_asset:felt):
    end

    func burnShares(_amount:Uint256, _tokenId:Uint256):
    end

    func mintShares(_amount:Uint256, _newSharesholder:felt, _sharePricePurchased:Uint256):
    end

    func receiveValidatedVaultAction(_action:Uint256, _actionData_len:felt, _actionData:Uint256):
    end




func receiveValidatedVaultAction{
        pedersen_ptr: HashBuiltin*, 
        syscall_ptr: felt*, 
        range_check_ptr
    }(
        _action: felt,
        _actionData_len:felt,
        _actionData:felt*,


    func getAssetBalance(_asset:felt) -> (assetBalance_: felt):
    end



    #NFT shit 
    func setName(name:felt):
    end

    func setSymbol(name:felt):
    end

    func getName() -> (name: felt):
    end

    func getSymbol() -> (symbol: felt):
    end

    func getTotalSupply() -> (totalSupply: Uint256):
    end

    func getBalanceOf(account: felt) -> (balance: Uint256):
    end

    func getAllowance(owner: felt, spender: felt) -> (remaining: Uint256):
    end

    func isAssetManager(who: felt) -> (isAssetManager_: felt):
    end

    func transferShares(recipient: felt, amount: Uint256) -> (success: felt):
    end

    func approve(spender: felt, amount: Uint256) -> (success: felt):
    end


end