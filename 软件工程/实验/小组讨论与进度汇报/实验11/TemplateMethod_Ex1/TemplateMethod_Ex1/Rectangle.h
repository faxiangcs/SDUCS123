//矩形，Shape的子类
class Rectangle : public Shape {
  double length;
  double width;
public:
	Rectangle(double l, double w);
  	void draw() ;
  	double getArea();
};
Rectangle::Rectangle(double l, double w):length(l),width(w){}
double Rectangle::getArea(){return (length*width);}  //override 
void Rectangle::draw(){cout<<"画矩形。"<<endl;}   //override
