%lang starknet

from starkware.cairo.common.uint256 import Uint256

struct VaultAction:
    member BurnShares: felt
    member MintShares: felt
    member TransferShares: felt
    member AddTrackedAsset: felt
    member ApproveAssetSpender: felt
    member RemoveTrackedAsset: felt
    member WithdrawAssetTo: felt
    member AddExternalPosition: felt
    member CallOnExternalPosition: felt
    member RemoveExternalPosition: felt
end
@contract_interface
namespace IVault:
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

    func transfer(recipient: felt, amount: Uint256) -> (success: felt):
    end

    func transferFrom(
            sender: felt, 
            recipient: felt, 
            amount: Uint256
        ) -> (success: felt):
    end

    func approve(spender: felt, amount: Uint256) -> (success: felt):
    end


end