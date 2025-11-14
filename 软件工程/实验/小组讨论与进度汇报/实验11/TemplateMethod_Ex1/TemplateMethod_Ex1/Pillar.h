#include "Shape.h"
//底由各种形状构成的柱体
class Pillar{  //三维柱体类; 只与抽象类Shape相关
	Shape& bottom; //类型兼容各种形状的底
	double height; 
 public:
 	Pillar(Shape& b, double h);
	void draw();        //画柱底面
	double getVolume(); //求柱体积
}; 
//构造函数初始化
Pillar::Pillar(Shape& b, double h):bottom(b),height(h){}
//求柱体积
double Pillar::getVolume(){return (bottom.getArea()*height);}
//画底面，由具体的bottom对像实现。
void Pillar::draw(){ cout<<"画柱体:底面"; bottom.draw(); }
