all:
	dotbot -c install.conf.yaml
	cargo install --path ./waybar/cpu-psi-waybar --root ~/.local/
