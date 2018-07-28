
.SUFFIXES:
#
.SUFFIXES: .cpp .o .c .h


.PHONY: clean cleandist

CXXFLAGS =  -std=c++11 -O2 -march=native -Wall -Wextra -Wshadow
#CXXFLAGS =  -std=c++11 -O2 -march=native -Wall -Wextra -Wshadow -Wno-implicit-function-declaration

EXECUTABLES=parse

EXTRA_EXECUTABLES=parsenocheesy parsenodep8

all: $(EXECUTABLES)
	-./parse

parse: main.cpp common_defs.h linux-perf-events.h
	$(CXX) $(CXXFLAGS) -o parse main.cpp

testflatten: parse parsenocheesy parsenodep8 
	for filename in jsonexamples/twitter.json jsonexamples/gsoc-2018.json jsonexamples/citm_catalog.json jsonexamples/canada.json ; do \
        	echo $$filename ; \
		set -x; \
		./parsenocheesy $$filename ; \
		./parse $$filename ; \
		./parsenodep8 $$filename ; \
		set +x; \
	done

parsenocheesy: main.cpp common_defs.h linux-perf-events.h
	$(CXX) $(CXXFLAGS) -o parsenocheesy main.cpp -DSUPPRESS_CHEESY_FLATTEN

parsenodep8: main.cpp common_defs.h linux-perf-events.h
	$(CXX) $(CXXFLAGS) -o parsenodep8 main.cpp -DNO_PDEP_PLEASE -DNO_PDEP_WIDTH=8


clean:
	rm -f $(EXECUTABLES) $(EXTRA_EXECUTABLES)

cleandist:
	rm -f $(EXECUTABLES) $(EXTRA_EXECUTABLES)
