CXX = g++
CC  = gcc
#CC = gcc-4.9
CFLAGS = -O2 -fopenmp
CFLAGS_TBB = -std=c++11 -O2 -fPIC -I$(TBB_INCLUDE)
LINKS_TBB  = -L$(TBB_LINK) -ltbb

FC = gfortran-4.9
FFLAGS = -O2 -fopenmp

#all: stream_f.exe stream_c.exe stream_tbb.exe
all: stream_c.exe stream_omp.exe stream_tbb.exe

stream_f.exe: stream.f mysecond.o
	$(CC) $(CFLAGS) -c mysecond.c
	$(FC) $(FFLAGS) -c stream.f
	$(FC) $(FFLAGS) stream.o mysecond.o -o stream_f.exe

stream_c.exe: stream.c
	$(CC) -O2 stream.c -o stream_c.exe

stream_omp.exe: stream.c
	$(CC) $(CFLAGS) stream.c -o stream_c.exe

stream_tbb.exe:
	 $(CXX) $(CFLAGS_TBB) stream-tbb.c -o stream_tbb.exe -D_USETBB=1 $(LINKS_TBB)

clean:
	rm -f stream_f.exe stream_c.exe stream_tbb.exe *.o

# an example of a more complex build line for the Intel icc compiler
stream.icc: stream.c
	icc -O3 -xCORE-AVX2 -ffreestanding -qopenmp -DSTREAM_ARRAY_SIZE=80000000 -DNTIMES=20 stream.c -o stream.omp.AVX2.80M.20x.icc
