
def lcs(s1, s2):
    n = len(s1)
    m = len(s2)
    dp = [[0] * (m + 1) for _ in range(n+1)]
    p = [[None] * (m + 1) for _ in range(n+1)]
    dp[0][0] = 0
    for i in range(1, n+1):
        for j in range(1, m+1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
                p[i][j] = (i-1, j-1, s1[i-1])
            else:
                # dp[i][j] = max(dp[i-1][j], dp[i][j-1])
                if dp[i-1][j] > dp[i][j-1]:
                    dp[i][j] = dp[i-1][j]
                    p[i][j] = (i-1, j, '')
                else:
                    dp[i][j] = dp[i][j-1]
                    p[i][j] = (i, j-1, '')
    ans = ''
    cur = p[n][m]
    while cur is not None:
        ans += cur[2]
        cur = p[cur[0]][cur[1]]
    print(dp)
    return ans[::-1]


if __name__=="__main__":
    s1 = "jfadkjfasfa;ld"
    s2 = " jkfjadsjfasdfasdfj"
    print(lcs(s1, s2))
