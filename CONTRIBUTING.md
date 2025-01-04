# CONTRIBUTING.md

This is my memo for vim9-brain development...

## Making up developing environment

I use Nix for creating development environment.
Use for creating development environment:

```bash
nix develop
# OR
nix-shell
```

I set up the vim's version for development. If you want to run vimscript, You should enter `nix-shell` to get the vim, then use `vim -S foofoo.vim`.

## Testing

I use `vim-themis` for Unit testing

```bash
themis -r
```

On the other hand, I use Nix for running unit tests.
Use:

```bash
nix flake check
```
