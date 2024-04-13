BITCOIND=bitcoind
BITCOINGUI=bitcoin-qt
BITCOINCLI=bitcoin-cli
B1_FLAGS=
B2_FLAGS=
B1=-datadir=1 $(B1_FLAGS)
B2=-datadir=2 $(B2_FLAGS)
BLOCKS=1
ADDRESS=
AMOUNT=
FEERATE=1
ADDRESSLABEL=
ADDRESSTYPE=
W1=wallet1
W2=wallet2
PORT1=19000
RPCPORT1=19001
PORT2=19010
RPCPORT2=19011

start:
	$(BITCOIND) $(B1) -daemon
	$(BITCOIND) $(B2) -daemon

start-gui:
	$(BITCOINGUI) $(B1) &
	$(BITCOINGUI) $(B2) &

generate:
	$(BITCOINCLI) $(B1) -generate $(BLOCKS)

getinfo:
	$(BITCOINCLI) $(B1) -getinfo
	$(BITCOINCLI) $(B2) -getinfo

sendfrom1:
	$(BITCOINCLI) $(B1) -named sendtoaddress address="$(ADDRESS)" amount=$(AMOUNT) fee_rate=$(FEERATE)

sendfrom2:
	$(BITCOINCLI) $(B2) -named sendtoaddress address="$(ADDRESS)" amount=$(AMOUNT) fee_rate=$(FEERATE)

address1:
	$(BITCOINCLI) $(B1) getnewaddress $(ADDRESSLABEL) $(ADDRESSTYPE)

address2:
	$(BITCOINCLI) $(B2) getnewaddress $(ADDRESSLABEL) $(ADDRESSTYPE)

stop:
	$(BITCOINCLI) $(B1) stop
	$(BITCOINCLI) $(B2) stop

clean:
	find 1/regtest/* -not -name 'server.*' -delete
	find 2/regtest/* -not -name 'server.*' -delete

docker-build:
	docker build -t bitcoin-testnet-box .

docker-run:
	docker run -t -i -p $(PORT1):$(RPCPORT1) -p $(PORT2):$(RPCPORT2) bitcoin-testnet-box

wallet1:
	$(BITCOINCLI) $(B1) createwallet $(W1)

wallet2:
	$(BITCOINCLI) $(B2) createwallet $(W2)

