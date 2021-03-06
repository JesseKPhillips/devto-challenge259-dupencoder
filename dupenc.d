import std.algorithm;
import std.typecons;
import std.stdio;
import std.range;
import std.meta;
import std.uni;
import std.conv;

const ONCE = '(';
const MANY = ')';

version(unittest) void main() {}
else
void main() {
    // List of inputs to utilize for graphing by length
    alias input = AliasSeq!(
        "Success",
        "The quick brown fox jumps overe the lazy dog. And we all want to know what happens when the dog wakes up.",
        "I am making up Words which I Utilizes for Doing a long sentance which shows how long things will Take as we Move Past the xerox machine. This is going to be a bit longer to really show some of that growth that happens as you get extra long and go past just a simple sentance.",
        );

    // Given a function and data set group, execute benchmarking against inputs
    void makeBenchmark(alias f)(string group) {
        import std.datetime : Duration;
        void plotData(string group, string[] input, Duration[] time) {
            import std.file : append;
            import std.string : format;
            writeln(group, " -");
            input.zip(time)
                .tee!(x => append(group~".dat", format("%s\t%s\n", x[0].length, x[1].total!"msecs")))
                .each!(x => writefln("Length %5s: %s", x[0].length, x[1]));
        }

        void callStringOnFunction(alias f, string s)() {
            f(s);
        }
        alias exec(string s) = callStringOnFunction!(f, s);

        import std.datetime.stopwatch : benchmark;
        auto results = benchmark!(staticMap!(exec, input))(10_000);
        plotData(group, [input], results[]);
    }

    ////
    // Specify the benchmark functions and group
    ////

    makeBenchmark!(duplicateEncode_php)("php");
    makeBenchmark!(duplicateEncode_haskell)("haskell");
    makeBenchmark!(duplicateEncode_pointer)("pointer");
    makeBenchmark!(duplicateEncode_go)("go");
    makeBenchmark!(duplicateEncode_go2)("go2");
}

// https://dev.to/jvanbruegge/comment/10e2g
string duplicateEncode_haskell(string input) {
    import std.string : representation;
    auto str = input.toLower().representation;

    return str.map!(x => str.filter!(c => c == x))
        .map!(x => x.take(2))
        .map!(x => x.count)
        .map!(x => x > 1 ? MANY : ONCE)
        .to!string;
} unittest {
    auto ans = duplicateEncode_haskell("Success");
    assert(ans == ")())())", ans);

    ans = duplicateEncode_haskell("(( @");
    assert(ans == "))((", ans);
}

// https://dev.to/peter279k/comment/10e45
string duplicateEncode_php(string str) {
    str = str.toLower();
    auto result = new char[](str.length);

    foreach(index, c; str) {
        bool isDuplicate = false;
        foreach(secondIndex, c2; str[index+1..$]) {
            if(c == c2) {
                result[index] = MANY;
                result[secondIndex+index+1] = MANY;
                isDuplicate = true;
            }
        }
        if(!isDuplicate && result[index] == char.init)
            result[index] = ONCE;
    }

    return result.to!string;
} unittest {
    auto ans = duplicateEncode_php("Success");
    assert(ans == ")())())", ans);

    ans = duplicateEncode_php("(( @");
    assert(ans == "))((", ans);
}

// https://forum.dlang.org/post/ottuukcltseoanhxmwab@forum.dlang.org
string duplicateEncode_pointer(string str) {
    import std.ascii : toLower;
    auto result = str.dup;
    char*[256] locMap;

    foreach(ref c; result)
    {
        auto p = &locMap[c.toLower()];
        if (*p)
            **p = c = MANY;
        else
        {
            c = ONCE;
            *p = &c;
        }
    }

    return result.to!string;
} unittest {
    auto ans = duplicateEncode_pointer("Success");
    assert(ans == ")())())", ans);

    ans = duplicateEncode_pointer("(( @");
    assert(ans == "))((", ans);
}

// https://dev.to/aminnairi/comment/10e63
string duplicateEncode_go(string str) {
    import std.ascii : toLower;
    char[] encoded;
    int[char] occurrences;
    encoded.reserve(str.length);

    foreach(char character; str)
        occurrences[toLower(character)]++;

    foreach(char character; str) {
        if(occurrences[toLower(character)] > 1)
           encoded ~= MANY;
        else
           encoded ~= ONCE;
    }

    return encoded.to!string;
} unittest {
    auto ans = duplicateEncode_go("Success");
    assert(ans == ")())())", ans);

    ans = duplicateEncode_go("(( @");
    assert(ans == "))((", ans);
}

// https://forum.dlang.org/post/ottuukcltseoanhxmwab@forum.dlang.org
string duplicateEncode_go2(string str) {
    import std.ascii : toLower;
    char[] encoded;
    int[256] occurrences;
    encoded.reserve(str.length);

    foreach(char character; str)
        occurrences[toLower(character)]++;

    foreach(character; str) {
        if(occurrences[toLower(character)] > 1)
           encoded ~= MANY;
        else
           encoded ~= ONCE;
    }

    return encoded.to!string;
} unittest {
    auto ans = duplicateEncode_go2("Success");
    assert(ans == ")())())", ans);

    ans = duplicateEncode_go2("(( @");
    assert(ans == "))((", ans);
}
