# The Cool Project Contracts Repository

The Cool project is a really cool project. It allows to create uncollaterallized loans on top of Aave V2 for impactful project that aim to make the planet great again.


## Truffle

To deploy contract on Kovan network:
```bash
npm run migrate:kovan
```

Then, update the addresses and abis in the `contracts` folder in the `web-app`.

## TODO

Short terms:
- Create forms to to whitelist someone.
- Update SC to allow someone to borrow.


Long terms:
- Implement conviction voting to whitelist new borrowers.
- Allow projects to run for being whitelisted.


## Utils


- DAI address: 0xff795577d9ac8bd7d90ee22b6c1703490b6512fd
- First account: 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73
- Address to whitelist: 0x627306090abaB3A6e1400e9345bC60c78a8BEf57

## Parameters

- decay = 0.9999599, which sets up conviction halftime to 3 days.
- maxRatio = 0.2, which sets the threshold formula to only allow proposals that request less than 20% of the funds.
- rho = 0.002, which fine tunes the threshold formula.
- minThresholdStakePercentage = 0.2, which sets the minimum percent of stake token active supply that is used for calculating the threshold

In 18 decimals numbers:
- decay = 999959900000000000
- maxRatio = 200000000000000000
- rho = 2000000000000000
- minThresholdStakePercentage = 200000000000000000

