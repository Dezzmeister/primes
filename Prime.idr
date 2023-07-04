module Prime

isPrime : Nat -> Bool
isPrime 0 = False
isPrime 1 = False
isPrime 2 = True
isPrime n = (factors n sqrtN == [n, 1]) where
    sqrtN : Nat
    sqrtN = the Nat ((cast . sqrt . cast) n)

    factors : Nat -> Nat -> List Nat
    factors n 0 = [n, 1] 
    factors n 1 = [n, 1]
    factors n l@(S k) = 
        let nn := natToInteger n
            nl := natToInteger l
        in
            case (mod nn nl == 0) of
                True => l :: (integerToNat (div nn nl)) :: (factors n k)
                False => factors n k

isEven : Nat -> Bool
isEven n = mod (natToInteger n) 2 == 0

nextPrime : Nat -> Nat
nextPrime m = 
    let n = if isEven m then S m else S (S m) in
        case isPrime n of
             True => n
             False => nextPrime (n + 2)

-- The type of all prime numbers. `Prime n` can only be constructed if `n` is prime.
-- The 'zeroth' prime is 2 because it is the first prime.
data Prime : Nat -> Type where
    PrimeZ : Prime 2
    PrimeS : Prime n -> Prime (nextPrime n)

-- Loosely typed mapping from natural numbers to primes
nthPrime : Nat -> Nat
nthPrime Z = 2
nthPrime (S k) = (nextPrime . nthPrime) k

-- Strongly typed mapping from natural numbers to primes
natToPrime : (n: Nat) -> Prime (nthPrime n)
natToPrime Z = PrimeZ
natToPrime (S k) = PrimeS (natToPrime k)

-- Maps the primes to the natural numbers
primeToNat : Prime n -> Nat
primeToNat PrimeZ = Z
primeToNat (PrimeS k) = S (primeToNat k)

-- Semigroup over a family of types indexed by a single natural number. This isn't perfect, partly
-- because it only allows for types with 1 index, and because 'dot' should be an operator like <+>.
-- For some reason there is a parse error when defining an operator with implicit parameters, so it is a
-- named function instead.
interface FamilySemigroup (f : Nat -> Type) where
    newIndex : {n : Nat} -> {m : Nat} -> f n -> f m -> Nat
    dot : {n : Nat} -> {m : Nat} -> (t1: f n) -> (t2: f m) -> f (newIndex t1 t2)

interface FamilyMonoid (f : Nat -> Type) where
    neutralIndex : Nat
    neutral : f neutralIndex

-- The semigroup operation defined over the prime numbers is formed by mapping the prime numbers
-- to their indices (the nth prime number has index n), adding the indices, and using the sum
-- to index into the prime numbers. The neutral element is therefore PrimeZ (2, n = 0) because
-- n + 0 = n, and PrimeZ + p = p.
FamilySemigroup Prime where
    newIndex p1 p2 = nthPrime ((primeToNat p1) + (primeToNat p2))
    dot a b = natToPrime ((primeToNat a) + (primeToNat b))

FamilyMonoid Prime where
    neutralIndex = 2
    neutral = PrimeZ
