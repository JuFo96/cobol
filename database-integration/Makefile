# Variables
PROGRAM = helloworld
OCESQL = ocesql
COBC = cobc

# Path
COBCPY = /home/jufo/Packages/Open-COBOL-ESQL-1.2/copy
OCLIB = /usr/local/lib

# Flags
COBCFLAGS = -x -I$(COBCPY)
LDLIBS = -locesql
COB_LDFLAGS = -Wl,-rpath,$(OCLIB)


# Default target
all: $(PROGRAM)

# Precompiler Open Cobol ESQL
%.cbl: %.cob
	$(OCESQL) $< $@

# GnuCobol Compiler
$(PROGRAM): $(PROGRAM).cbl
	COB_LDFLAGS="$(COB_LDFLAGS)" \
	$(COBC) $(COBCFLAGS) $< $(LDLIBS) -o $@

# Clean up
clean:
	rm -f $(PROGRAM).cbl $(PROGRAM)

# Run the program
run: $(PROGRAM)
	./$(PROGRAM)

.PHONY: clean run