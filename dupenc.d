import std;

version(unittest) void main() {}
else
void main() {
    import std.datetime.stopwatch : benchmark;
    void duplicateEncode_nested_success() {
        duplicateEncode_nested("Success");
    }
    benchmark!(duplicateEncode_nested_success)(10_000).each!writeln;
}

string duplicateEncode_nested(string str) {
    str = str.toLower();
    auto result = new char[](str.length);

    foreach(index, c; str) {
        bool isDuplicate = false;
        foreach(secondIndex, c2; str[index+1..$]) {
            if(c == c2) {
                result[index] = ')';
                result[secondIndex+index+1] = ')';
                isDuplicate = true;
            }
        }
        if(!isDuplicate && result[index] == char.init)
            result[index] = '(';
    }

    return result.to!string;
} unittest {
    auto ans = duplicateEncode_nested("Success");
    assert(ans == ")())())", ans);

    ans = duplicateEncode_nested("(( @");
    assert(ans == "))((", ans);
}
