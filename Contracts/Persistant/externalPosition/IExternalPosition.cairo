%lang starknet

@contract_interface
namespace IExternalPosition:
    func receiveCallFromVault(_actionData_len: felt,_actionData: felt*):
    end

end
