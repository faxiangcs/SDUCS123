// 测试 底为不同形状（圆、矩形）的柱体体积 的测试程序。 
#include <iostream>
using namespace std;
#include"Shape.h"
#include"Circle.h"
#include"Rectangle.h"
#include"Pillar.h"

int main() {
	Circle c1(1.0);  //底为圆
  	Shape& s1=c1;
  	Pillar p1(s1, 10);
  	cout<<"圆柱体积："<< p1.getVolume()<<endl;
  	p1.draw(); 
  	
  	Rectangle r1(3.0,2.0);  //底为矩形
  	Shape& s2=r1;
  	Pillar p2(s2, 10);
  	cout<<"矩形柱体积："<< p2.getVolume()<<endl;
  	p2.draw();
  
  return 0;
} 
