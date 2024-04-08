# Question 4

**Script kiddies:** Source or come up with a text manipulation problem and solve it with at least two of awk, sed, tr. and / or grep. Check the question below first though, maybe.

# Answer

```
$ echo "I have 3 dogs, namely; one, two, three" > dog.txt
```
Here's I am using sed to demonstrate text manipulation. So the problem is that the dogs name is not spelled correctly given I am spanish.

```
sed -i 's/one/uno/g' dog.txt
sed -i 's/two/dos/g' dog.txt
sed -i 's/three/tres/g' dog.txt
```