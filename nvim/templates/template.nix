{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  shellHook = "%HERE%";
}
