# Solidity Hands-On

A hands-on learning project for Solidity smart contract development, featuring ERC20 and ERC721 token implementations with an "Orcs" theme.

## Project Structure

```
solidity-hands-on/
├── contracts/
│   ├── CyberOrcs.sol          # ERC20 fungible token
│   ├── OrcsNFT.sol            # ERC721 non-fungible token
│   ├── Ownable.sol            # Access control contract
│   └── interfaces/
│       ├── ICyberOrcs.sol     # ERC20 interface
│       ├── IOrcsNFT.sol       # ERC721 interface
│       ├── IERC20.sol         # Standard ERC20 interface
│       ├── IERC173.sol        # Ownership interface
│       ├── IERC721Receiver.sol
│       └── IMetadata.sol
```

## Smart Contracts

### CyberOrcs (ERC20)

A fungible token contract with:

- Standard ERC20 functionality (transfer, approve, transferFrom)
- Owner-controlled minting
- Token burning capability
- 18 decimal places

### OrcsNFT (ERC721)

A non-fungible token contract with:

- NFT minting and burning
- Token URI support with base URI
- Safe transfer mechanisms
- Approval and operator support

### Ownable

Access control contract implementing ERC173:

- Ownership transfer and renunciation
- `onlyOwner` modifier for restricted functions

## Using with Remix IDE

### Import from GitHub

1. Open [Remix IDE](https://remix.ethereum.org)
2. In the Git panel on the left, click on the **"Clone"** section
3. Enter the repository URL:
   ```
   https://github.com/mtoub/solidity-hands-on
   ```
4. In the "Branch" field, specify `main` (or leave blank for default)
5. Click **"clone"** to clone the repository
6. The contracts will appear in the "File Explorer"

## Compiling and Deploying

1. **Select Compiler**: Go to the "Solidity Compiler" tab and select version `0.8.24` or higher
2. **Compile**: Click "Compile" on the contract you want to deploy
3. **Deploy**:
   - Go to the "Deploy & Run Transactions" tab
   - Select your environment (e.g., "Remix VM" for testing)
   - Select the contract to deploy
   - Provide constructor arguments if needed:
     - **CyberOrcs**: `name`, `symbol`, `maxSupply`
     - **OrcsNFT**: `name`, `symbol`, `baseURI`
   - Click "Deploy"

## Requirements

- Solidity ^0.8.24
- OpenZeppelin Contracts (automatically resolved by Remix)

## Learning Topics

This project covers:

- ERC20 token standard implementation
- ERC721 NFT standard implementation
- Access control patterns (Ownable/ERC173)
- Solidity interfaces and inheritance
- Token minting, burning, and transfers
- Events and error handling

## License

MIT
