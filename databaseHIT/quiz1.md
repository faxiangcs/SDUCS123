# 数据库系统课堂测验（2024年4月24日）

学号：2023140004

姓名：阎发祥

1. 用SQL查询姓王的学生，并按照所在院系和学号的字典序排序。（10分）

```sql 
SQL select * from student where Sname like '王%' order by Sdept,Sno
```
   
2. 用关系代数和SQL查询选修了'1002'号课程的学生的学号和姓名。（20分）

```sql
RA  π Sno,Sname (σ Cno='1002' (Student ⨝ SC))     
SQL select Sno,Sname from student natural join sc where Cno='1002'
```
  
3. 用关系代数和SQL查询选修了'1002'号课程但没选修'2003'号课程的学生的学号和姓名。（20分）

```sql
RA  π Sno,Sname (σ Cno='1002' (SC⨝Student))-π Sno,Sname (σ Cno='2003' (SC⨝Student))
SQL select Sno, Sname from student  
where Sno in (select Sno from sc where Cno = '1002') and Sno not in (select Sno from sc where Cno = '2003')
```

4. 用关系代数和SQL查询所有学生选课的数量，列出学号、姓名和选课数。（20分）

```sql
RA   γ Sno,Sname;count(*)->cnt (Student⨝SC)
SQL  select Sno,Sname,count(*) from student natural join sc group by Sno  
```

5. 用SQL查询选修了2门以上（含2门）课程且平均分不低于80的学生的学号、姓名。（10分）

```sql
SQL  select Sno,Sname from student natural join sc group by Sno having count(*)>=2 and avg(Grade)>=80 
```

6. `SELECT * FROM Student AS S1 NATURAL JOIN Student AS S2`的结果是什么？（10分）

```
全体学生的信息
```

7. `SELECT Sno FROM Student WHERE NOT EXISTS (SELECT * FROM SC WHERE SC.Sno = Student.Sno)`的结果是什么？（10分）
```
没有选课信息的学生的学号
```
   