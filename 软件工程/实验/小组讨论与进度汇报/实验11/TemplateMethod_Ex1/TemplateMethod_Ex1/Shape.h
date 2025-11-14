#ifndef _SHAPE_H
#define _SHAPE_H

class Shape {  //二维图形 
 public:
  	virtual void draw() = 0;  //模版方法
  	virtual double getArea() = 0; //模版方法
};

#endif