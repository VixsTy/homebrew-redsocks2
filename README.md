# Redsocks2 homebrew formula

This Homebrew formula allow your to build and install a redsocks2 on a MacOS environment.

The original redsocks is not compliant with MacOS PF, and support only FreeBSD PF.
Worst, the redsocks Homebrew-core formula install an iptables compliant binary.

Why do we need a redsocks working with pf ?
* The best way to work with redsocks is to use pf to redirect tcp packets to redsocks.
  * the common way to redirect, is to change the destination ip. So redsocks NAT the packets received and need to access your firewall (PF / IPTABLES) to know the original destination.
