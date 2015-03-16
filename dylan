
#include <vector>
#include <iostream>
#include <fstream>
#include <cmath>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>  
#include <list>
#include "Shape.h"
#include "Primitive.h"

inline float sqr(float x) { return x*x; }

using namespace std;

//****************************************************
// Some Classes
//****************************************************
class PointLight;

class PointLight {
public:
	Point* point = new Point(0.0, 0.0, 0.0);
	Color* color = new Color(0.0, 0.0, 0.0);
	PointLight(Point* p, Color* c) {
		point = p;
		color = c;
	}
};

class DirectionalLight;

class DirectionalLight {
public:
	Vector* direction = new Vector(0.0, 0.0, 0.0);
	Color* color = new Color(0.0, 0.0, 0.0);
	DirectionalLight(Vector* d, Color* c) {
		direction = d;
		color = c;
	}
};

int main(int argc, char *argv[]){

	Vector ll,lr,ul,ur,eye;
	list<Sphere> spheres;
	list<Triangle*> triangles;
	list<PointLight> pointLights;
	list<DirectionalLight> directionalLights;
	Color ambientLight;
	Material material(new BRDF());

	int i = 0;
	while(i<argc){ 
    if (strcmp(argv[i],"cam")==0) {
      eye = Vector(atof(argv[i+1]),atof(argv[i+2]),atof(argv[i+3]));
      ll = Vector(atof(argv[i+4]),atof(argv[i+5]),atof(argv[i+6]));
      lr = Vector(atof(argv[i+7]),atof(argv[i+8]),atof(argv[i+9]));
      ul = Vector(atof(argv[i+10]),atof(argv[i+11]),atof(argv[i+12]));
      ur = Vector(atof(argv[i+13]),atof(argv[i+14]),atof(argv[i+15]));
      i+=16;
    }
    else if (strcmp(argv[i],"sph")==0){
      Sphere sphere = Sphere(atof(argv[i+1]),atof(argv[i+2]),atof(argv[i+3]),atof(argv[i+4]));
      spheres.push_back(sphere);
      i+=5;
    }
    else if (strcmp(argv[i],"tri")==0) {
      Point *pt1 = new Point(atof(argv[i+1]),atof(argv[i+2]),atof(argv[i+3]));
      Point *pt2 = new Point(atof(argv[i+4]),atof(argv[i+5]),atof(argv[i+6]));
      Point *pt3 = new Point(atof(argv[i+7]),atof(argv[i+8]),atof(argv[i+9]));
      Triangle* triangle = new Triangle(pt1,pt2,pt3);
      triangles.push_back(triangle);
      i+=10;
    }
    else if (strcmp(argv[i],"ltp")==0) {
      //doesn't support falloff
      Point* point = new Point(atof(argv[i+1]),atof(argv[i+2]),atof(argv[i+3]));
      Color* color = new Color(atof(argv[i+4]),atof(argv[i+5]),atof(argv[i+6]));
      PointLight pointLight = PointLight(point, color);
      pointLights.push_back(pointLight);
      i+=7;
    }
    else if (strcmp(argv[i],"ltd")==0) {
      Vector* direction = new Vector(atof(argv[i+1]),atof(argv[i+2]),atof(argv[i+3]));
      Color* color = new Color(atof(argv[i+4]),atof(argv[i+5]),atof(argv[i+6]));
      DirectionalLight directionalLight = DirectionalLight(direction, color);
      directionalLights.push_back(directionalLight);
      i+=7;
    }
    else if (strcmp(argv[i],"lta")==0) {
      ambientLight = Color(atof(argv[i+1]),atof(argv[i+2]),atof(argv[i+3]));
      i+=4;
    }
    else if (strcmp(argv[i],"mat")==0) {
      Color* ka = new Color(atof(argv[i+1]),atof(argv[i+2]),atof(argv[i+3]));
      Color* kd = new Color(atof(argv[i+4]),atof(argv[i+5]),atof(argv[i+6]));
      Color* ks = new Color(atof(argv[i+7]),atof(argv[i+8]),atof(argv[i+9]));
      Color* kr = new Color(atof(argv[i+10]),atof(argv[i+11]),atof(argv[i+12]));
      BRDF* brdf = new BRDF(kd, ks, ka, kr);
      material = Material(brdf);
      i+=13;
    }
    else if (strcmp(argv[i],"xft")==0) {
      
      i+=7;
    }
    else if (strcmp(argv[i],"xfr")==0) {
      
      i+=7;
    }
    else if (strcmp(argv[i],"xfs")==0) {
      
      i+=7;
    }
    else {
      i+=1;
    }
  }

    
	Point* v = new Point(1, 2, 3);
	
	Point* b = new Point(3, 4, 5);
	//cout << v->x << endl;
	Vector *line = (*v) - *b;
	Normal *nmm = new Normal(line);
	

	LocalGeo *lg = new LocalGeo();
	

	Ray* ray = new Ray(new Point(0, 0, 0), new Vector(0, 0, 1));
	float t_hit;
	Sphere* sp2 = new Sphere(0, 0, 4, 1);

	
	Point *pt1 = new Point(0, 0, 1);
	Point *pt2 = new Point(-1, 1,3);
	Point *pt3 = new Point(1, 2, 2);
	Triangle* tri = new Triangle(pt1, pt2, pt3);
	cout << "checking for triangle intersection:" << (*tri).intersect(*ray,&t_hit,lg) << endl;
	cout << "t_hit" << t_hit << endl;
	cout << "normal:";
	(*lg).print();
	Color* color = new Color(1, 1, 1);
	Color* color2 = new Color(2, 1, 1);
	Color* color3 = new Color(3, 1, 1);
	Shape* shape = tri;
	Material *mat = new Material(new BRDF(color, color,color, color));
	Material *mat2 = new Material(new BRDF(color2, color2, color2, color2));
	Material *mat3 = new Material(new BRDF(color3, color3, color3, color3));
	Matrix* m = new Matrix(1, 3, 2, 1);
	Transformation* tra = new Transformation(m);
	tra->m->print();
	tra->minvt->print();
	/*
	lg = (*tra)*(lg);
	lg->normal->print();
	*/

	Primitive *p1 = new GeometricPrimitive(tra, tra, tri, mat);
	GeometricPrimitive *p2 = new GeometricPrimitive(tra, tra, tri, mat2);
	GeometricPrimitive *p3 = new GeometricPrimitive(tra, tra, tri, mat3);

	vector<Primitive*> pri;
	pri.push_back( p1);
	pri.push_back(p2);
	pri.push_back(p3);

	AggregatePrimitive* prigrand = new AggregatePrimitive(pri);
	GeometricPrimitive *p4 = (GeometricPrimitive*) (prigrand->primitives[2]);
	p4->mat->constantBRDF->print();



	system("pause");
	return 0;
	return 0;
}
