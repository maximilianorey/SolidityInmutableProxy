import "@atixlabs/hardhat-time-n-mine";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-solhint";
import "@nomiclabs/hardhat-waffle";
import "@openzeppelin/hardhat-upgrades";
import "@typechain/hardhat";
import "hardhat-contract-sizer";
import "hardhat-deploy";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "solidity-docgen";

// This is done to have the new matchers from waffle,
// because despite the note in https://hardhat.org/guides/waffle-testing.html?#adapting-the-tests
// the changeEtherBalance is not added because its a newer version
import chai from "chai";
import { config as dotenvConfig } from "dotenv";
import { solidity } from "ethereum-waffle";
import { HardhatUserConfig } from "hardhat/config";
import { NetworkUserConfig } from "hardhat/types";
import { removeConsoleLog } from "hardhat-preprocessor";
import { resolve } from "path";

chai.use(solidity);

dotenvConfig({ path: resolve(__dirname, "./.env") });

const chainIds = {
  ganache: 1337,
  goerli: 5,
  hardhat: 31337,
  kovan: 42,
  mainnet: 1,
  rinkeby: 4,
  ropsten: 3,
  rskTestnet: 31,
  binanceTestnet: 97,
};

// Ensure that we have all the environment variables we need.
let mnemonic: string;
if (!process.env.mnemonic) {
  throw new Error("Please set your mnemonic in a .env file");
} else {
  mnemonic = process.env.mnemonic;
}

const createTestnetConfig = (
  network: keyof typeof chainIds
): NetworkUserConfig => {
  let url = "http://127.0.0.1:8545";
  if (network === "rskTestnet") {
    url = "https://public-node.testnet.rsk.co";
  }
  if (network === "binanceTestnet") {
    url = "https://data-seed-prebsc-2-s2.binance.org:8545";
  }
  return {
    accounts: {
      count: 10,
      initialIndex: 0,
      mnemonic,
      path: "m/44'/60'/0'/0",
    },
    chainId: chainIds[network],
    url,
    timeout: 100000,
  };
};

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  namedAccounts: {
    deployer: 0,
    holder: 1,
    nonHolder: 2,
    controller00: 10,
    controller01: 11,
    controller02: 12,
    investor00: 13,
    investor01: 14,
    investor02: 15,
    nonWhitelisted: 16,
    universalGiver00: 17,
    universalGiver01: 18,
  },
  networks: {
    hardhat: {
      accounts: {
        mnemonic,
        count: 40,
      },
      chainId: chainIds.hardhat,
      blockGasLimit: 30000000, // 30M polygon block gas limit
    },
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    goerli: createTestnetConfig("goerli"),
    kovan: createTestnetConfig("kovan"),
    rinkeby: createTestnetConfig("rinkeby"),
    ropsten: createTestnetConfig("ropsten"),
    rskTestnet: createTestnetConfig("rskTestnet"),
    binanceTestnet: createTestnetConfig("binanceTestnet"),
  },
  paths: {
    artifacts: "./artifacts",
    cache: "./cache",
    sources: "./contracts",
    tests: "./test",
  },
  solidity: {
    version: "0.8.7",
    settings: {
      // https://hardhat.org/hardhat-network/#solidity-optimizer-support
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  typechain: {
    outDir: "typechain",
    target: "ethers-v5",
    alwaysGenerateOverloads: false,
  },
  /*gasReporter: {
    enabled: process.env.REPORT_GAS ? true : false,
    currency: "USD",
    coinmarketcap: "5fd5c88b-ed66-4243-81ab-9870cf2eed7f",
    token: "MATIC",
    gasPriceApi:
      "https://api.polygonscan.com/api?module=proxy&action=eth_gasPrice",
    excludeContracts: ["EchidnaTest", "Mockup"],
  },*/
  preprocess: {
    eachLine: removeConsoleLog(
      (hre) => !["hardhat", "localhost"].includes(hre.network.name)
    ),
  },
  docgen: {
    pages: "files",
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: false,
  },
};

export default config;
