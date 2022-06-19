import { ethers, Wallet } from "ethers";

import { ERC20P__factory } from "./typechain";
import { ProxyDeployer2__factory } from "./typechain/factories/ProxyDeployer2__factory";

const provider = new ethers.providers.JsonRpcProvider({
  url: "http://localhost:8545",
});

async function run() {
  const wallet = Wallet.fromMnemonic(
    "recycle excess begin share mystery source bright phone champion walk among group"
  ).connect(provider);

  const erc20 = new ERC20P__factory(wallet);
  const erc20Instance = await erc20.deploy();

  const pr = new ProxyDeployer2__factory(wallet);

  const prInstance = await pr.deploy();

  console.log(erc20Instance.address);

  const tr = await (await prInstance.deployProxy(erc20Instance.address)).wait();
  console.log(JSON.stringify(tr.events, undefined, 2));
  const addr = tr.events![0].args![0];

  console.log(addr);

  const erc20P = ERC20P__factory.connect(addr, wallet);
  await (await erc20P.init()).wait();
  const trMint = await (await erc20P.mint(wallet.address, 20)).wait();
  console.log("TR MINT EVENT");
  console.log(JSON.stringify(trMint.events, undefined, 2));
  const trTransfer = await (await erc20P.transfer(erc20P.address, 5)).wait();
  console.log("TR TRANSFER EVENT");
  console.log(JSON.stringify(trTransfer.events, undefined, 2));
  console.log("WALLET BALANCE");
  console.log(await erc20P.balanceOf(wallet.address));
  console.log("ERC20 BALANCE");
  console.log(await erc20P.balanceOf(erc20P.address));
  console.log("NAME");
  console.log(await erc20P.name());
  console.log("SYMBOL");
  console.log(await erc20P.symbol());

  const tr2 = await (
    await prInstance.deployProxy(erc20Instance.address)
  ).wait();
  console.log(JSON.stringify(tr2.events, undefined, 2));
  const addr2 = tr2.events![0].args![0];

  console.log(addr2);

  const erc20P2 = ERC20P__factory.connect(addr2, wallet);
  await (await erc20P2.init2("A NAME 2", "N2")).wait();
  const trMint2 = await (await erc20P2.mint(wallet.address, 20)).wait();
  console.log(JSON.stringify(trMint2.events, undefined, 2));
  const trTransfer2 = await (await erc20P2.transfer(erc20P2.address, 5)).wait();
  console.log(JSON.stringify(trTransfer2.events, undefined, 2));
  console.log(await erc20P2.balanceOf(wallet.address));
  console.log(await erc20P2.balanceOf(erc20P2.address));
  console.log("NAME");
  console.log(await erc20P2.name());
  console.log("SYMBOL");
  console.log(await erc20P2.symbol());
}

run().catch((err) => console.error(err));
