import std;

const ONCE = '(';
const MANY = ')';

version(unittest) void main() {}
else
void main() {
    import std.datetime.stopwatch : benchmark;
    void duplicateEncode_php_success() {
        duplicateEncode_php("Success");
    }
    void duplicateEncode_haskel_success() {
        duplicateEncode_haskel("Success");
    }

    auto functionNames = [
        "Dlang PHP",
        "Dlang Haskel",
    ];

    functionNames.zip(benchmark!(
               duplicateEncode_php_success,
               duplicateEncode_haskel_success,)(10_000)[])
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
