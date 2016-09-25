
# Library locations
MPI_LOC = /opt/openmpi
FFTW_LOC = /opt/fftw-3.3.4

# The compiler
CXX = $(MPI_LOC)/bin/mpic++

# Compiler parameters
# -Wall		shows all warnings when compiling
# -std=c++11	enables the C++11 standard
# -O3		optimization
CXXFLAGS = -Wall -std=c++11 -O3

# Linker parameters
LFLAGS = -L$(FFTW_LOC)/lib -lfftw3_mpi -lfftw3 -lm

# Name of the applications
APP = bin/pfc

# Application compilation settings
APP_CXXFLAGS = $(CXXFLAGS) -Iinclude -I$(FFTW_LOC)/include

# Object files
OBJS = obj/main.o obj/pfc.o obj/mechanical_equilibrium.o

####################
# MAIN APP TARGETS #
####################

# Default target to run all targets to build the application
all: $(APP)

# Target that links the objects to the executable
# NB: objects are a dependency
$(APP): $(OBJS)
	$(CXX) $(OBJS) -o $(APP) $(LFLAGS)

# Target that compiles sources to object files
obj/%.o: src/%.cpp
	$(CXX) $(APP_CXXFLAGS) -c $< -o $@

run:
	$(MPI_LOC)/bin/mpirun -n 2 $(APP)

#################
# OTHER TARGETS #
#################

doc:
	doxygen

clean:
	rm -f $(OBJS)
	rm -f $(APP)
	rm -rf docs/html

