build:
	docker run --rm -it -w /project -v ./:/project gowin_builder gw_sh ./Makefile.tcl

load:
	openFPGALoader -b tangnano9k -m impl/pnr/project.fs

docker:
	docker build -t gowin_builder .

run:
	make build
	make load