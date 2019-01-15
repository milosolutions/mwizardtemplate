#CONFIG += asan

asan {
    message("Address sanitizer: enabled. Use only in debug builds")
    CONFIG += sanitizer sanitize_address
    QMAKE_CXXFLAGS+="-fsanitize=address -fno-omit-frame-pointer"
    QMAKE_CFLAGS+="-fsanitize=address -fno-omit-frame-pointer"
    QMAKE_LFLAGS+="-fsanitize=address"
    CONFIG += ubsan
}

msan {
    message("Memory sanitizer: enabled. Use only in debug builds. Use only with clang")
    QMAKE_CXXFLAGS+="-fsanitize=memory"
    QMAKE_LFLAGS+="-fsanitize=memory"
    CONFIG += ubsan
}

tsan {
    message("Thread sanitizer: enabled. Use only in debug builds")
    QMAKE_CXXFLAGS+="-fsanitize=thread"
    QMAKE_LFLAGS+="-fsanitize=thread"
    CONFIG += ubsan
}

ubsan {
    message("Undefined behavior sanitizer: enabled. Use only in debug builds")
    QMAKE_CXXFLAGS+="-fsanitize=undefined"
    QMAKE_LFLAGS+="-fsanitize=undefined"
}
