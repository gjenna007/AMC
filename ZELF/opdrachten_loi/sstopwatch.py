from time import perf_counter
from math import sqrt
class Stopwatch:
    """ Provides stopwatch objects that that programmers
    can use to time the execution time of portions of
    a program. """
    def __init__(self):
        """ Makes a new stopwatch ready for timing. """
        self.reset()
    def start(self):
        """ Starts the stopwatch, unless it is already running.
        This method does not affect any time that may have
        already accumulated on the stopwatch. """
        if not self._running:
            self._start_time = perf_counter() - self._elapsed
            self._running = True # perf_counter now running
    def stop(self):
        """ Stops the stopwatch, unless it is not running.
        Updates the accumulated elapsed time. """
        if self._running:
            self._elapsed = perf_counter() - self._start_time
            self._running = False # Clock stopped
    def reset(self):
        """ Resets stopwatch to zero. """
        self._start_time = self._elapsed = 0
        self._running = False
    def elapsed(self):
        """ Reveals the stopwatch running time since it
        was last reset. """
        if not self._running:
            return self._elapsed
        else:
            return perf_counter() - self._start_time
        
def count_primes(n):
    """
    Generates all the prime numbers from 2 to n - 1.
    n - 1 is the largest potential prime considered.
    """
    timer = Stopwatch()
    timer.start() # Record start time
    count = 0
    for val in range(2, n):
        root = round(sqrt(val)) + 1
        # Try all potential factors from 2 to the square root of n
        for trial_factor in range(2, root):
            if val % trial_factor == 0: # Is it a factor?
                break # Found a factor
        else:
            count += 1 # No factors found
    timer.stop() # Stop the clock
    print("Count =", count, "Elapsed time:", timer.elapsed(), "seconds")
def sieve(n):
    """
    Generates all the prime numbers from 2 to n - 1.
    n - 1 is the largest potential prime considered.
    Algorithm originally developed by Eratosthenes.
    """
    timer = Stopwatch()
    timer.start() # Record start time
    # Each position in the Boolean list indicates
    # if the number of that position is not prime:
    # false means "prime," and true means "composite."
    # Initially all numbers are prime until proven otherwise
    nonprimes = n * [False] # Global list initialized to all False
    count = 0
    # First prime number is 2; 0 and 1 are not prime
    nonprimes[0] = nonprimes[1] = True
    # Start at the first prime number, 2.
    for i in range(2, n):
        # See if i is prime
        if not nonprimes[i]:
            count += 1
            # It is prime, so eliminate all of its
            # multiples that cannot be prime
            for j in range(2*i, n, i):
                nonprimes[j] = True
    # Print the elapsed time
    timer.stop()
    print("Count =", count, "Elapsed time:", timer.elapsed(), "seconds")
def main():
    count_primes(2000000)
    sieve(2000000)

main()        