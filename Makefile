.PHONY: bootstrap destroy install-all upgrade-all install delete upgrade test dashboard

bootstrap: 
	@echo "==> Bootstraping cluster ..."
	@bash scripts/bootstrap.sh

destroy:
	@echo "==> Destroying cluster ..."
	@bash scripts/destroy.sh

install:
	@echo "==> Installing app $(app) ..."
	@bash scripts/manage-app.sh install $(app)

upgrade:
	@echo "==> Upgrading app $(app) ..."
	@bash scripts/manage-app.sh upgrade $(app)

delete:
	@echo "==> Deleting app $(app) ..."
	@bash scripts/manage-app.sh delete $(app)

install-all: 
	@echo "==> Installing all apps ..."
	@bash scripts/manage-all-apps.sh install

upgrade-all: 
	@echo "==> Upgrading all apps ..."
	@bash scripts/manage-all-apps.sh upgrade

delete-all: 
	@echo "==> Deleting all apps ..."
	@bash scripts/manage-all-apps.sh delete

test:
	@echo "==> Test local registry ..."
	@bash test/local-registry.sh

dashboard:
	@echo "==> Run kubernetes dashboard command ${cmd} ..."
	@bash dashboard/run.sh ${cmd}