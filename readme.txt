=================================== Primes ===================================

Some Idris code that defines the type of all prime numbers and some related
functions. This is only possible in a language with dependent typing.

Examples:
    `PrimeZ` has type `Prime 2` because the zeroth prime is 2
    `PrimeS PrimeZ` (analog to Peano numbers) has type `Prime 3` (successor to first prime)
    `PrimeS (PrimeS PrimeZ)` has type `Prime 5`
    ... and so on

    The 'dot' function is defined for all Primes. It mirrors the addition operator
    for natural numbers. Given the nth prime and the mth prime, 'dot' will give
    back the (n + m)th prime. The neutral element is the 0th prime, `PrimeZ`.

    dot PrimeZ (PrimeS PrimeZ) = PrimeS PrimeZ
    dot (PrimeS PrimeZ) (PrimeS PrimeZ) = PrimeS (PrimeS PrimeZ)
    ... and so on

