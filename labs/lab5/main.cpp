#include <iostream>
#include <cstring>

using namespace std;

void add_char(char c) {
    cout << c;
}

extern void add_char_wrapper(char c);

int main() {
    char input[255] = {};
    cout << "Enter the text:\n";
    cin.getline(input, 255);
    cout << "Enter how many words must be deleted?\n";
    int n;
    cin >> n;
    cout << "Now enter word indexes one by row\n";
    int indexes[129];
    for (int i = 0; i < n; ++i) {
        cin >> indexes[i];
    }
    indexes[n] = 9000;

    // является ли текущая буква первой
    bool is_first = true;
    // нужно ли пропускать текущее слово
    bool should_skip = false;
    // индекс текущего слова
    int current_index = 0;
    // индекс следующего пропускаемого слова
    int next_skippable_index = 0;

    for (int i = 0; input[i] != '\0'; ++i) {
        char c = input[i];
        if (c == ' ') {
            is_first = true;
            add_char_wrapper(c);
        } else {
            if (is_first) {
                is_first = false;
                should_skip = false;
                current_index += 1;
                if (current_index == indexes[next_skippable_index]) {
                    next_skippable_index += 1;
                    should_skip = true;
                }
            }
            if (!should_skip) {
                add_char_wrapper(c);
            }
        }
    }
}