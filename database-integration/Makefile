# Variables
PROGRAM = helloworld
OCESQL = ocesql
COBC = cobc
PSQL = psql

# Path
COBCPY = lib/Open-COBOL-ESQL-1.2/copy
#OCLIB = /usr/local/lib # Seemingly not needed with static linking

# Flags
COBCFLAGS = -x -static -I$(COBCPY)
LDLIBS = -locesql
#COB_LDFLAGS = -Wl,-rpath,$(OCLIB) # Seemingly not needed with static linking


# Default target
all: $(PROGRAM)

# Precompiler Open Cobol ESQL
%.cbl: %.cob
	$(OCESQL) $< $@

# GnuCobol Compiler
$(PROGRAM): $(PROGRAM).cbl
	$(COBC) $(COBCFLAGS) $< $(LDLIBS) -o $@


# Quick debugging helpers
db-create:
	$(PSQL) -U postgres -c "CREATE DATABASE $(DB);"


db-drop:
	$(PSQL) -U postgres -c "DROP DATABASE IF EXISTS $(DB);" 


db-test:
	$(PSQL) -U postgres -d testdb -c "SELECT 1;"

# Clean up
clean:
	rm -f $(PROGRAM).cbl $(PROGRAM)

# Run the program
run: $(PROGRAM)
	./$(PROGRAM)

.PHONY: clean run db-create db-drop db-test