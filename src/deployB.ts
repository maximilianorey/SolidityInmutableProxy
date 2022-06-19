/*import { ethers, Wallet } from "ethers";

import { Dummy__factory, ProxyDeployer2B__factory } from "./typechain";

const provider = new ethers.providers.JsonRpcProvider({
  url: "http://localhost:8545",
});

async function run() {
  const wallet = Wallet.fromMnemonic(
    "recycle excess begin share mystery source bright phone champion walk among group"
  ).connect(provider);

  const dummy = new Dummy__factory(wallet);
  const dummyInstance = await dummy.deploy();

  const pr = new ProxyDeployer2B__factory(wallet);

  const prInstance = await pr.deploy();

  console.log(dummyInstance.address);

  console.log(await prInstance.test(dummyInstance.address));

  console.log(`DUMMY DIRECT: ${(await dummyInstance.getQ(1)).toString()}`);

  const tr = await (await prInstance.deployProxy(dummyInstance.address)).wait();
  console.log(JSON.stringify(tr.events, undefined, 2));
  const addr = tr.events![0].args![0];

  console.log(addr);

  console.log(await dummyInstance.getCode(addr));

  const proxyDummy = Dummy__factory.connect(addr, wallet);

  console.log((await proxyDummy.getQ(1)).toString());
  //console.log(await (await proxyDummy.setQ(2, 15)).wait());
}

run().catch((err) => console.error(err));
*/
