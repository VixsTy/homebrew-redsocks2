# Redsocks2 homebrew formula

This Homebrew formula allow you to build and install a redsocks2 binary on a MacOS environment.

## Difference with the homebrew-core redsocks formula ?

The original [darkk/redsocks](https://github.com/darkk/redsocks) is not compliant with MacOS PF, and support only FreeBSD PF.
Worst, the Homebrew-core redsocks formula install an iptables compliant binary.

So i found an active fork [semigodking/redsocks](https://github.com/semigodking/redsocks) and add some fix to correctly build and working on MacOS

Why do we need a redsocks working with pf ?
* The best way to work with redsocks is to use pf to redirect tcp packets to redsocks.
  * the common way to redirect, is to change the destination ip. So redsocks NAT the packets received and need to access your firewall (PF / IPTABLES) to know the original destination.
