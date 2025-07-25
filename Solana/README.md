# 🧠 What is Solana
Solana ek high-performance blockchain platform hai jo decentralized applications (dApps) aur crypto tokens ke liye use hota hai.

### ✅ Keywords:*
<pre><br>Fast (65,000+ transactions per second)

Cheap (fee ~ $0.00025)

Scalable (no Layer-2 needed)<br></pre>

## 🧱 Solana ke Core Components:
Hum Solana ko 10 important parts me divide karte hain:

## 1. 🪙 SOL Token
Solana ka native token hai: SOL

Use hota hai transaction fees, staking aur smart contracts me

### 💡 1 SOL = 1,000,000,000 lamports

# 2. 🏗️ Programs (Smart Contracts)
Rust ya C se likhe jaate hain

Blockchain pe deploy hote hain

Logic run karte hain jaise:

Token banana

NFT mint karna

Voting app

Games, DeFi etc.

## 📁 Yeh “on-chain logic” hoti hai (jese backend server blockchain pe)

# 3. 👛 Accounts
Sab kuch account hota hai: user, program, data

### 2 types:

  ### System Account: Wallet (SOL hold karta hai)

  ### Program Account: Logic/data store karta hai

🧠 Important: Har account ka apna owner program hota hai.

# 4. 💡 PDAs (Program Derived Addresses)
Special account jise koi program control karta hai

Deterministic hoti hai: program + seed se generate hoti hai

Private key nahi hoti — program hi control karta hai

Use hoti hai NFT metadata, token authority, etc. me

# 5. ⛓️ Transactions
Ek transaction me multiple instructions hoti hain

Transaction ka signature user deta hai

📥 Input: sender's account, 📤 Output: receiver’s account

# 6. ⚙️ Instructions
Ek single action: like mint token, transfer SOL, etc.

Program ko specific task karne ka hukm

Example: create_metadata_accounts_v3(...) is an instruction

# 7. 🛠️ BPF & Anchor
BPF (Berkeley Packet Filter): Solana ka low-level VM

Anchor: Framework jo Rust smart contracts banana asaan banata hai

Anchor ki tarah samjho: React for Solana

# 8. 🔑 Keypairs & Wallets
Public key = Address

Private key = Signature banata hai

Wallets:

Phantom

Solflare

CLI wallet

Paper / hardware wallets

# 9. 🌐 Clusters
Solana ke 3 major environments:
<pre><br>
Cluster   	 Purpose
devnet	     Testing with fake SOL
testnet	     Pre-mainnet testing
mainnet	     Real production blockchain<br></pre>

# 10. 🔄 Rent & Storage
Account ko blockchain pe zinda rakhne ke liye "rent" chahiye

Agar lamports rent se kam ho jaayein → account delete ho sakta hai

