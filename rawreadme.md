
<!-- stable coin using real world ether price feched from the chainlink oracle data feed   -->
Stable Coin buiding project setup guide

1. first Deploy the USDT Contract, this contract will act as the stable coin collateral of USDT. we're using 20% of 1 Million tokens as stable collateral. 

After that mint 200000 USDT tokens in wei, i.e  200000000000000000000000


2. After that deploy the weth.sol smart contract and let it be.

3. Deploy the Reserves.sol smart contract. Once deployed, add the address of Reserves.sol for approve function in the USDT.sol and add collateral amount i.e, 200000000000000000000000


in addReserve function first add the USDT.sol address and then WETH.sol address

id 0 is for USDT and 1 is for WETH Collateral

now run Deposit function and deposit 200000000000000000000000 from 0 pid. 


verify amount by checking the rsvVault  for 0 id. 

4. Deploy the PriceOracle.sol and run the setDataFeedAddress from chainlink datafeed. 
(we're using ETH/USD so get the ETH/USD Address https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&network=hedera&search=#hedera-testnet )

5. deploy the governance-option1.sol and add the USDT.sol smart contract address in the constructor. 
   
   add the addresses of the collateral tokens i.e USDT and WETH in the addColateralToken function one by one.

<!-- Building stage remaining after this point -->
   after that set the data feed address by running the setDataFeedAddress function and pass the datafeed address of the ETH/USD pair. 

      after that set the reserve.sol reserve smart contract address by running the reservesmartcontract function. 

6. in the reserve smart contract run the fetch collateral price to get the real-time ETH/USD value from chainlink oracle.
   check the value in unstablecolprice variable and convert it from wei to ETH.

    800000/real-time eth price in eth

    
7. now mint these output amount of eth in wei from the mint function of weth.sol 
    now run the approve function 
     add the deployed address of the reserve.sol  
     and the amount you have just minted in weth wei or any endless amount it dosen't matter as we're not transferring them now.

8. in reserve.sol deposit the amount you've just minted in weth wei to the id 1.

9. in n2usd.sol grantRole function add the address of the governance.sol  and output of the mangaer_role variable 

10. now mint 1 Million in wei 1000000000000000000000000 n2usd token from the mint function of n2usd.sol
    transer 500000000000000000000000 to governance.sol so that it can burn or mint new tokens to balance the peg price of stable coin.


    in governance.sol, run the validatepeg function  to equalize the stable collateral amount.

    now check the n2dsupply and you should see the stabalized amount that is balanced according to the peg. 

11. in reserve.sol run the withdraw function (a way to simulate dropping the value of our eth i.e WETH) for checking  how the n2usdsupply is adjusted to balance the peg amount. for pid 1 and the amount of eth you wish to withdraw. 

    in governance.sol and then run validatepeg function to update collateral price again check the value of the n2usdsupply from governance.sol  

    



    <!-- 26.40 timestamp for the blog -->
<!-- deploying the stablecoin with custom unstable collateral coin, this unstable collateral coin will act as real world ether, however with this fake ether we'll be able to fluctuate the price as we wish and witness the stablecoin auto rebalnce the collateral itself after executing the validate peg function.   -->
<!-- deployment process with custom fake unstable collateral n2dr token -->
    fake usdt
    n2dr token smart contract
    reserves smart contract
    n2usd stablecoin contract
    governance smart contract


Important: imitate price fluctuation in token with setn2drTokenPrice function of governance contract


<!-- execution process -->

1. mint 200K wei USDT collateral from USDT.sol file
2. in USDT.sol provide approval to reserves address and 200K wei amount
3. mint 1Billion wei n2dr token in n2DR contract
4. in n2DR contract approve reserves and governance smart contract address 1Billion wei token 
5. in resrves.sol  addReserves collateral address USDT & N2DR tokens 
6. in deposit function of reserves.sol at 0 pid deposit 200Kwei and at 1 pid deposit 10000000 wei tokens verify them later in the rsvVault function.
7. in n2usd contract mint 1000000 wei N2usd tokens
8. in governance contract run addcollateraltoken function and enter usdt and n2dr token address
9. after that run the setReserveContract function and add the reserve contract address.
10. in n2dr token add the address of governance contract in the grantRole function and manager role bytes 32 output.
11. in governance contract run setN2drTokenPrice with value 80000000 (this is the price which you want your stable coin to be at all the time (80000000/1Billion = 0.08 ether is the price our stable coin will be auto rebalancing to)) and after that set the n2usd supply to be 1000000 wei  
    1.  transfer 500000000 n2dr tokens to the governance smart contract.
    2.  run the validate peg function. 
    3.  check the unstable collateral amount it should display 10 million n2dr tokens
    4.  check the unstable collateral price it should be around 0.08 (ether strikethrough here)
    5.  check the stable collateral amount it should display 200k wei tokens
    6.  check the stable collateral price it should be around 1^18
    7.  n2dsupply should be 1 Billion tokens still 
    8.  now again change the setn2drTokenPrice to something else and then run validate peg to verify if coin is stabalizing to the price of 1 dollar.
    
    that's it! 

12. build the backend and connect it with blockchain.
13. move on to building the frontend and backend and integrating them both together. 

