
################################################################################
#
# lradc_check
#
################################################################################

LRADC_CHECK_VERSION = v0.2
LRADC_CHECK_SITE = https://github.com/AdenoBluesky/lradc_check.git
LRADC_CHECK_SITE_METHOD = git

LRADC_CHECK_LICENSE = MIT
# 現状 README に MIT と書いてあるので、とりあえずそれをライセンスファイル扱い
LRADC_CHECK_LICENSE_FILES = README.md

# Rust / cargo 用の標準的なおまじない
LRADC_CHECK_CARGO_ENV = \
	CARGO_HOME=$(HOST_DIR)/usr/share/cargo \
	RUST_TARGET_PATH=$(HOST_DIR)/etc/rustc

# 必要なら追加オプションも指定できる（多分不要）
# LRADC_CHECK_CARGO_BUILD_OPTS = --bin lradc_check

# パッケージディレクトリへのパス（外部ツリーに合わせて調整）
LRADC_CHECK_PKGDIR = $(BR2_EXTERNAL)/package/lradc_check

################################################################################
# Init script installation
################################################################################

define LRADC_CHECK_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 \
		$(LRADC_CHECK_PKGDIR)/S99lradc_check.in \
		$(TARGET_DIR)/etc/init.d/S99lradc_check
	$(SED) 's,@PORT@,$(BR2_PACKAGE_LRADC_CHECK_PORT),g' \
		$(TARGET_DIR)/etc/init.d/S99lradc_check
endef

define LRADC_CHECK_INSTALLATION_AUTOSTART
	$(LRADC_CHECK_INSTALL_INIT_SYSV)
endef

LRADC_CHECK_POST_INSTALL_TARGET_HOOKS += LRADC_CHECK_INSTALLATION_AUTOSTART

# Buildroot の cargo-package インフラを使用
$(eval $(cargo-package))
