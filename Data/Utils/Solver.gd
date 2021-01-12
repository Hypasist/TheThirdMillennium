class_name solver

static func isValid(M):
    var y = M.size()
    var x = M[0].size()
    for i in y:
        if M[i].size() != x:
            print("Inconsistent matrix size: %d != %d!" % [M[i].size(), x])
            return false
        for j in x:
            if M[i][j] == null:
                print("Matrix with null value found! [%d][%d]" % [i, j])
                return false
    return true


static func printM(M):
    if isValid(M):
        for i in range(0, M.size()):
            print(M[i])


static func negateM2New(M):
    var N = createNew(M.size(), M[0].size())
    for y in M.size():
        for x in M[y].size():
            N[y][x] = -M[y][x]
    return N


static func negateM2Self(M):
    for y in M.size():
        for x in M[y].size():
            M[y][x] = -M[y][x]


static func createNewValue(y, x, v):
    var N = []
    for i in y:
        N.append([])
        for j in x:
            N[i].append(v)
    return N
    

static func createNew(y, x):
    return createNewValue(y, x, 0)
    
    
static func multiplyM(M1, M2):
    if M1[0].size() != M2.size():
        print("Wrong size of matrixes! %d != %d" % [M1[0].size(), M2.size()])
        return null
    var s = 0
    var N = createNew(M1.size(), M2[0].size())
    
    for y in M1.size():
        for x in M2[0].size():
            s = 0
            for i in M2.size():
                s += M1[y][i] * M2[i][x]
            N[y][x] = s
    return N


static func addM(M1, M2):
    if M1.size() != M2.size() || M1[0].size() != M2[0].size():
        print("Wrong size of matrixes! %d != %d // %d != %d" % [M1.size(), M2.size(), M1.size(), M2.size()])
        return null
    var N = createNew(M1.size(), M1[0].size())
    for y in M1.size():
        for x in M1[0].size():
            N[y][x] = M1[y][x] + M2[y][x]
    return N
    
    
static func calcVectorNorm(V):
    var s = 0
    for x in V[0].size():
        s += pow(V[0][x], 2)
    return sqrt(s)
    
    
static func calcMinor_4andOver(mat, ban_y, ban_x):
    var size = mat.size() - 1
    var offset_x = 0
    var offset_y = 0
    var tmp_sum = 0
    var tmp_mult = 1
    
    for diag in range (0, size):
        tmp_mult = 1
        for crawler in range (0, size):
            offset_y = 1 if (crawler) % size >= ban_y else 0
            offset_x = 1 if (diag + crawler) % size >= ban_x else 0
#            print(((crawler) % size) + offset_y, "  ", ((diag + crawler) % size) + offset_x)
            tmp_mult *= mat[((crawler) % size) + offset_y][((diag + crawler) % size) + offset_x]
        tmp_sum += tmp_mult
        
        tmp_mult = -1
        for crawler in range (0, size):
            offset_y = 1 if (crawler) % size >= ban_y else 0
            offset_x = 1 if (diag + size - crawler) % size >= ban_x else 0
#            print(((crawler) % size) + offset_y, "  ", ((diag + size - crawler) % size) + offset_x) 
            tmp_mult *= mat[((crawler) % size) + offset_y][((diag + size - crawler) % size) + offset_x]
        tmp_sum += tmp_mult
    
    return tmp_sum
    
    
static func calcMinor_3andUnder(mat, ban_y, ban_x):
    var size = mat.size()
    match size:
        1:
            print("Can't calculate a minor of 1-size matrix!")
            return null
        2:
            return mat[size - ban_y - 1][size - ban_x - 1]
        3:
            var array = []
            for y in range (0, size):
                if y == ban_y: continue
                for x in range(0, size):
                    if x == ban_x: continue
                    array.append(mat[y][x])
            
            return array[0] * array[3] - array[1] * array[2]
                    
    
static func calcMinor(mat, ban_y, ban_x):
    if mat.size() > 3: return calcMinor_4andOver(mat, ban_y, ban_x)
    if mat.size() < 4: return calcMinor_3andUnder(mat, ban_y, ban_x)
    
    
static func inverse_mat(mat):
    if mat.size() != mat[0].size():
        print("Wrong size of matrixes! %d == %d" % [mat.size(), mat[0].size()])
        return null
    
    var n = mat.size()
    var coeffs = createNew(n, n)
    var adjugate = createNew(n, n)
    for y in range(0, n):
        for x in range(0, n):
            coeffs[y][x] = calcMinor(mat, y, x) * (1 if ((y+x) % 2 == 0) else -1)
            
    for y in range(0, n):
        for x in range(0, n):
            adjugate[y][x] = coeffs[x][y]
    
    var det = 0
    for x in range(0, n):
        det += mat[0][x] * coeffs[0][x]
        
    for y in range(0, n):
        for x in range(0, n):
            adjugate[y][x] /= float(det) 
            
    return adjugate
       

static func transposeM2New(M):
    var N = createNew(M[0].size(), M.size())
    for y in M.size():
        for x in M[y].size():
            N[x][y] = M[y][x]
    return N
    

static func solve_linear(A, Y):
    var invA = inverse_mat(A)
    return multiplyM(invA, Y)
    
    
static func solve_nonlinear(A, B, _F, _J, prec):
    var precision = pow(1.0, prec)
    
    var rng = RandomNumberGenerator.new()
    rng.randomize()
    var cycle = 0
    var approx
    var B_vector = []
    for i in B.size():
        B_vector.append([B[i]])
    var diff = null
    var F = null
    var J = null
    
    print("START:")
    printM(B_vector)
    print(" ")
    negateM2Self(B_vector)
    
    for j in 50:
        approx = []
        for i in B.size():
            approx.append([rng.randf_range(-100.0, 100.0)])
            
        for i in 20:
            cycle = i
            F = _F.call_func(A, B, approx)
            J = _J.call_func(A, B, approx)
            diff = solve_linear(J, negateM2New(F))
            if calcVectorNorm(diff) <= precision: break
            approx = addM(approx, diff)
            cycle = null
            
        if calcVectorNorm(addM(B_vector, approx)) > precision && cycle:
            print("Found! gen = ", j, " cycle = ", cycle)
            printM(approx)
            print(" ")
            break
        elif j == 49 && cycle == null:
            print("Not found!")
        
    return approx
func init():
    pass
    
    
    
    
    
