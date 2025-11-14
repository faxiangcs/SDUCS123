//Ô²£¬¹«ÓÐ¼Ì³ÐShape
class Circle : public Shape {
 private:
 	static double PI;
  	double radius;
 public:
	Circle(double r);
  	void draw() ; 
  	double getArea();
};
double Circle::PI=3.141592653;
Circle::Circle(double r):radius(r){}
double Circle::getArea(){return (PI*radius*radius);} //override
void Circle::draw(){cout<<"»­Ô²¡£"<<endl;}   //override
