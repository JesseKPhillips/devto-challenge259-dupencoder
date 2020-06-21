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
    import std.datetime.stopwatch : benchmark;
    auto functionNames = AliasSeq!(
        "short PHP", () => duplicateEncode_php("Success"),
        "short Haskel" ,() => duplicateEncode_haskel("Success"),
        "short Pointer" ,() => duplicateEncode_pointer("Success"),
    );

    [Stride!(2, functionNames[0..$])]
        .zip(benchmark!(
               Stride!(2, functionNames[1..$])
               )(10_000)[])
        .each!(x => writefln("%20s: %s", x[0], x[1]));
}

// https://dev.to/jvanbruegge/comment/10e2g
string duplicateEncode_haskel(string str) {
    str = str.toLower();
    return str.map!(x => str.filter!(c => c == x))
        .map!(t => t.count > 1 ? MANY : ONCE)
        .to!string;
} unittest {
    auto ans = duplicateEncode_haskel("Success");
    assert(ans == ")())())", ans);

    ans = duplicateEncode_haskel("(( @");
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

string duplicateEncode_pointer(string str) {
    import std.ascii : toLower;
    auto result = str.dup;
    char*[][char] locMap;

    foreach(ref c; result)
        locMap[c.toLower] ~= &c;

    foreach(v; locMap)
        if(v.length > 1)
            v.each!(x => *x = MANY);
        else
            v.each!(x => *x = ONCE);

    return result.to!string;
} unittest {
    auto ans = duplicateEncode_pointer("Success");
    assert(ans == ")())())", ans);

    ans = duplicateEncode_pointer("(( @");
    assert(ans == "))((", ans);
}
