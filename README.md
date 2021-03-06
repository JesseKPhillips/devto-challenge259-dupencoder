[Dev.to](https://dev.to/) has a daily challenge and I happened upon the [Duplicate Encoder #259 for 2020](https://dev.to/thepracticaldev/daily-challenge-259-duplicate-encoder-2e8l)

I didn't really want to solve the challenge per se, so instead I took the top comments for implementation and wrote them in [D Lang](https://dlang.org/).

For clarity these are all implemented in D and do not reflect the language performance that the implementation is based on.

![Latest Graph](graph.png)

The "Haskell" implementation utilizes a range based map/filter approach to detecting duplicates.

The "PHP" implementation utilizes a nested loop apporach to intentify that the character occurs again.

The "Pointer" implementation was just something I wanted to try. It duplicates the array so it is mutable
after which point it does not loop over the arry twice and instead stores pointers to the location of the
same character. It takes quite a bit for this approach to see any performance gain.

----

The Haskell implementation was modified to put its performance within the relm of competition.

[Commit for Change](https://github.com/JesseKPhillips/devto-challenge259-dupencoder/commit/c794a71328f46ea5c2bccadd2658b03e387ed1db)

![Graph Showing Haskell Change](haskell.png)

A final modification to the Haskell implementation shows another improvement. This approach was the only
one which had the potential of correctly handling unicode, as such I've removed that possability by
representing everything as a char instead of dchar. This optimization didn't assist the others.

This change places Haskell's approach in competation with Go.

[Commit for Change](https://github.com/JesseKPhillips/devto-challenge259-dupencoder/commit/90c26b97fb73e12e8f01bea922477c7c8e107e04)

![Haskell with no Unicode](haskell2.png)

----

I posted to the the [D Forum](https://forum.dlang.org/post/ottuukcltseoanhxmwab@forum.dlang.org) and
recieved a recommendation for updating the pointer algorithm to make it the fastest. And I made that change.

[Commit for Change](https://github.com/JesseKPhillips/devto-challenge259-dupencoder/commit/867afc95afbc16f06135061a890b1893b12a3bfc)

![Pointer Improvement](pointer2.png)
