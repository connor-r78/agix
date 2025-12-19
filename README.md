To compile the operating system and open it in QEMU, run `kernel/compile.zsh`

Agix is intended to be an agentic operating system done right (unlike Windows 11). In order to accomplish that it does the following:

1. Has most of its components written in Zig.
2. Minimizes the AI to updating and refactoring those compdnents rather than shoving it down your throat in every single application.
3. Everything can run locally not on some mainframe computer in California.
4. Being Unix-like and mostly POSIX-compliant.

## Why Zig?

Zig might seem like a strange choice for a project of this scale as it is still yet to reach Major Version 1; alas, Zig has certain advantages over other systems programming languages in this use case.

In addition to having the most robust unit testing system in any language that I have seen:

it is safer than C;
it has a better community than C++;
it has a community, unlike Ada and D;
it has better C FFI performance than Go;
it has compile-time execution unlike Pascal;
and it has shorter compile times than Rust.

## Roadmap to 1.0.0

* [x] Working VGA
* [ ] Full ANSI keyboard support
* [ ] UNIX coreutils
* [ ] C + Zig compilers
* [ ] Package manager
* [ ] Vim port!!
* [ ] Desktop environment
* [ ] Sound
* [ ] Mouse input (is this really necessary?)
* [ ] Doom (obviously...)
* [ ] Firefox
* [ ] Agentic capabilities using BitChat (or a fork thereof)
