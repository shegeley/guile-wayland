shell-default-args = \
	guile-next \
	guile-ares-rs \
	--no-substitutes

nrepl-exp = "((@ (nrepl server) run-nrepl-server) \#:port 7888)"

guile = ${shell-default-args} -- guile -L .

toplevel:
	guix shell \
	-f guix.scm guile \
	-- guile -L . -s \
	foreign-toplevel/wayland.scm

nrepl:
	guix shell -f guix.scm ${guile} -e ${nrepl-exp}
