# Contributing to jinx

On principle I welcome all contributions to jinx. Whether it be code refactoring, 
adding new features or whatever else you can think of. The only thing I ask you
is to [behave excellently](https://github.com/pretzelhands/jinx/blob/master/CODE_OF_CONDUCT.md)
while you're working on `jinx`.

## Pull requests

I will try to get around to every pull request as quickly as possible. Due to me 
running a freelance business it might sometimes take a while until I get the chance.
In general I'm not too fuzzy about coding standards. Here's an approximate workflow
you can expect.

**After you submit a pull request:**

* I'll take a quick look at the pull request and let you know by when I'll get around to it
* I'll do a more in-depth review of the code and either ask you to adapt or merge it into the appropriate branch
* With the next release it'll be merged into `master`.

As you can see it's a really informal process. Also when you submit something don't forget to add yourself 
to [the Contributors section](https://github.com/pretzelhands/jinx#contributors) in the README. Credit where
credit is due. 😊

## Issues

I'll do my best to label and triage all issues. If you have one that you'd like to work on, please leave a quick
comment that you're looking at it. Feel free to pick up any issue that seems interesting to you.

Once you're done working on it, the same flow as for pull requests applies.

## Code structure

You'll find that 90% of the functionality lives outside of the main `jinx` file. This is so I can keep an overview
of the code without getting lost. I politely ask you to adhere to the module structure/naming already established.

Feel free to add new modules if the functionality you're building doesn't fit anywhere else.

## Versioning

I try to adhere to [Semantic Versioning](https://semver.org/) as best I can. Things might be a bit different
while we're in 0.x.y (as in, breaking changes might happen as part of a minor release), but as soon as we hit 1.0.0
Semantic Version is a hard rule. Please keep this in mind.

That's all. Now go have fun! ✨
