all:
	cargo install --path ./waybar/cpu-psi-waybar --root ~/.local/
	dotbot -c install.conf.yaml
