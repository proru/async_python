# num = int(input())


def fibonacci(n):
	#complete the recursive function
	cur = 0
	temp =1
	for item in range(n-1):
		print(cur)
		cur, temp = temp, cur + temp
	print(cur)
	# if n<3:
	# 	return 1
	# temp = fibonacci(n-1) + fibonacci(n-2)
	# print(temp)
	# return temp

# fibonacci(num)


def validate(number):
	import re
	#your code goes here
	# number = int(input())
	result = 'Valid'
	finds = re.findall('[^0-9]',number)
	if finds:
		result = 'Invalid'
	finds = re.findall('^[189]?',number)
	if finds[0] == "" or len(number)!=8:
		result = 'Invalid'
	print(result)


if __name__=='__main__':
	print('hello')
	validate("573456h2")
	validate("97345632")
	validate("37345632")
