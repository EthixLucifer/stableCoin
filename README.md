# Algorithmic-Stablecoin-ERC20
🤑The Official ERC20 Algoritmic Stablecoin Project Tutorial Repo - Complete repo on how to deploy your own algorithmic stablecoin and back it with a hybrid collateral reserve between other stablecoins or cryptocurrencies.


** THE FILES ATTACHED TO THIS REPO ARE FOR EDUCATIONAL PURPOSES ONLY **

** NOT FINANCIAL ADVISE **

** USE IT AT YOUR OWN RISK** **I'M NOT RESPONSIBLE FOR ANY USE, ISSUES ETC.. **


<h4>Step 1</h4>

Download the "Final" Folder, then navigate with your shell/terminal to each project folder and install:

```shell
cd final
cd backend
npm i

cd..
cd frontend
npm i
```


<h4>Step 2</h4>

In the "config.js" on frontend and "getprices.js" on the backend, you can either use the already configured test smart contract addresses or add your own contract addresses. Make sure you update the RPC address as well (if needed).

```shell
const rsvcontract = '0xba1f546071d9d7E2388d420AC1091ce58F661Efc';
const n2usdcontract = '0x480724B920B486af30610b5Ed6456B0113951F43';
const rpc = 'https://rpc.ankr.com/polygon_mumbai';
```

CTRL + S to save!

<h4>Step 3</h4>

Run the backend and await the database to store more than 12 entries before running the frontend. Verify both ethpricedb.json and n2usdpricedb.json files to confirm. 

```shell
cd final
cd backend
node backend.js
```


<h4>Step 4</h4>

Run the Frontend to live visualize the token price!

```shell
cd final
cd frontend
npm run dev
```

<img src="https://raw.githubusercontent.com/net2devcrypto/misc/main/stablechart.png" width="500" height="400">
