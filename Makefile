.PHONY: deploy dry-run ssh help

help:
	@echo "make deploy    - 同步网站到 nh.acmeacme.net"
	@echo "make dry-run   - 预览本次会同步哪些文件，不实际修改服务器"
	@echo "make ssh       - SSH 登录服务器"

deploy:
	./deploy.sh

dry-run:
	./deploy.sh --dry-run

ssh:
	ssh -i $$HOME/.ssh/ssh-key-oracle-nh.key ubuntu@129.150.45.122
