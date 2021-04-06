class HighScoreTable:
    def __init__(self, amount):
        self.amount = amount
        self.scores = []


    def update(self, score):
        self.scores.append(score)
        self.scores.sort(reverse=True)
        self.scores = self.scores[0:self.amount]

    def reset(self):
        self.scores = []


# YOUR CODE HERE


if __name__ == '__main__':
    highScoreTable = HighScoreTable(4)
    highScoreTable.update(4)
    highScoreTable.update(5)
    highScoreTable.update(7)
    highScoreTable.update(8)
    print(highScoreTable.scores)

    highScoreTable = HighScoreTable(3)
    highScoreTable.update(10)
    print(highScoreTable.scores)
    highScoreTable.update(8)
    print(highScoreTable.scores)
    highScoreTable.update(12)
    print(highScoreTable.scores)
    highScoreTable.update(5)
    print(highScoreTable.scores)
    highScoreTable.update(10)
    print(highScoreTable.scores)
    highScoreTable.update(10)
    print(highScoreTable.scores)
    highScoreTable.update(20)
    print(highScoreTable.scores)
    highScoreTable.update(20)
    print(highScoreTable.scores)
    highScoreTable.update(20)



