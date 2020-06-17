import std;

void main() {
}

string duplicateEncode_basic(string str) {

    return str;
} unittest {
    assert(duplicateEncode_basic("Success") == ")())())");
    assert(duplicateEncode_basic("(( @") == "))((");
}
