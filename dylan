
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

#define PI 3.14159265  // Should be used from mathlib
inline float sqr(float x) { return x*x; }

using namespace std;

//****************************************************
// Some Classes
//****************************************************

//  all classes need func

class Vector;

class Vector {
public: 
	float x, y, z;
	Vector(float a, float b, float c) {
		x = a;
		y = b;
		z = c;
	}
};

Vector addVector(Vector a, Vector b) {return Vector(a.x+b.x, a.y+b.y, a.z+b.z);}
Vector subVector(Vector a, Vector b) {return Vector(a.x-b.x, a.y-b.y, a.z+b.z);}
Vector scale(Vector a, float b) {return Vector(a.x*b, a.y*b, a.z*b);}
Vector normalize(Vector a) {
	float mag = sqrt(sqr(a.x) + sqr(a.y) + sqr(a.z));
	return Vector(a.x/mag, a.y/mag, a.z/mag);
}

class Normal;

class Normal {
public:
	float x, y, z;
	Normal(float a, float b, float c) {
		x = a;
		y = b;
		z = c;
	}
};


class Point;

class Point {
public:
	float x, y, z;
	Point(float a, float b, float c) {
		x = a;
		y = b;
		z = c;
	}
};

Vector getDirectionVector(Point a, Point b) {return Vector(a.x-b.x, a.y-b.y, a.z-b.z);}
// I'm not sure about this...
Point addPoint(Point a, Vector b) {return Point(a.x+b.x, a.y+b.y, a.z+b.z);}
Point subPoint(Point a, Vector b) {return Point(a.x-b.x, a.y-b.y, a.z-b.z);}

class Ray;

class Ray {
public:
	Point pos;
	Vector dir;
	float t_min, t_max;
};

class Matrix;

class Matrix {
public:
	float mat[4][4];
};

class Color;

class Color {
public:
	float r, g, b;
	Color(float x, float y, float z) {
		r = x;
		g = y;
		b = z;
	}
};

class Sample;

class Sample {
public:
	float x, y;
};

class BRDF;

class BRDF {
public:
	Color kd, ks, ka, kr;
	BRDF(Color d, Color s, Color a, Color r) {
		kd = d;
		ks = s;
		ka = a;
		kr = r;
	}
};

class LocalGeo;

class LocalGeo {
public:
	Point position = new Point(0.0, 0.0, 0.0);
	Normal normal = new Normal(0.0, 0.0, 0.0);
	LocalGeo(Point p, Normal n) {
		position = p;
		normal = n;
	}
};

class PointLight;

class PointLight {
public:
	Point point = new Point(0.0, 0.0, 0.0);
	Color color = new Color(0.0, 0.0, 0.0);
	PointLight(Point p, Color c) {
		point = p;
		color = c;
	}
};

class DirectionalLight;

class DirectionalLight {
public:
	Vector direction = new Vector(0.0, 0.0, 0.0);
	Color color = new Color(0.0, 0.0, 0.0);
	PointLight(Vector d, Color c) {
		direction = d;
		color = c;
	}
};

class Material;

class Material {
public:
	BRDF constantBRDF;
	Material(BRDF brdf) {
		constantBRDF = brdf;
	}
};


int main(int argc, char *argv[]){

	Vector ll,lr,ul,ur,eye;
	list<Sphere> spheres;
	list<Triangle> triangles;
	list<PointLight> pointLights;
	list<DirectionalLight> directionalLights;
	Color ambientLight;
	Material material;

	while(i<argc){ 
    if (strcmp(argv[i],"cam")==0) {
      eye = new Vector(argv[i+1],argv[i+2],argv[i+3]);
      ll = new Vector(argv[i+4],argv[i+5],argv[i+6]);
      lr = new Vector(argv[i+7],argv[i+8],argv[i+9]);
      ul = new Vector(argv[i+10],argv[i+11],argv[i+12]);
      ur = new Vector(argv[i+13],argv[i+14],argv[i+15]);
      i+=16;
    }
    else if (strcmp(argv[i],"sph")==0){
      Sphere sphere = new Shere(argv[i+1],argv[i+2],argv[i+3]);
      shapes.push_back(sphere);
      i+=4;
    }
    else if (strcmp(argv[i],"tri")==0) {
      Point pt1 = new Point(argv[i+1],argv[i+2],argv[i+3]);
      Point pt2 = new Point(argv[i+4],argv[i+5],argv[i+6]);
      Point pt3 = new Point(argv[i+7],argv[i+8],argv[i+9]);
      Triangle triangle = new Triangle(pt1,pt2,pt3);
      triangles.push_back(triangle);
      i+=10;
    }
    else if (strcmp(argv[i],"ltp")==0) {
      //doesn't support falloff
      Point point = new Point(argv[i+1],argv[i+2],argv[i+3]);
      Color color = new Color(argv[i+4],argv[i+5],argv[i+6]);
      PointLight pointLight = new PointLight(point, color);
      i+=7;
    }
    else if (strcmp(argv[i],"ltd")==0) {
      Vector direction = new Vector(argv[i+1],argv[i+2],argv[i+3]);
      Color color = new Color(argv[i+4],argv[i+5],argv[i+6]);
      DirectionalLight directionalLight = new DirectionalLight(direction, color);
      directionalLights.push_back(directionalLight);
      i+=7;
    }
    else if (strcmp(argv[i],"lta")==0) {
      ambientLight = new Color(argv[i+1],argv[i+2],argv[i+3]);
      i+=4;
    }
    else if (strcmp(argv[i],"mat")==0) {
      Color ka = new Color(argv[i+1],argv[i+2],argv[i+3]);
      Color kd = new Color(argv[i+4],argv[i+5],argv[i+6]);
      Color ks = new Color(argv[i+7],argv[i+8],argv[i+9]);
      Color kr = new Color(argv[i+10],argv[i+11],argv[i+12]);
      BRDF brdf = new BRDF(kd, ks, ka, kr);
      material = new Material(brdf);
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
	cout << v->x << endl;
	Vector *line = (*v) - *b;
	Normal *nmm = new Normal(line);
	(*nmm).print();

	LocalGeo *lg = new LocalGeo();
	

	Ray* ray = new Ray(new Point(0, 0, 0), new Vector(0, 0, 1));
	double t_hit;
	Sphere* sp2 = new Sphere(0, 0, 4, 1);

	
	Point *pt1 = new Point(0, 0, 1);
	Point *pt2 = new Point(-1, 1,3);
	Point *pt3 = new Point(1, 2, 2);
	Triangle* tri = new Triangle(pt1, pt2, pt3);
	cout << "checking for triangle intersection:" << (*tri).intersect(*ray,&t_hit,lg) << endl;
	cout << "t_hit" << t_hit << endl;
	cout << "normal:";
	(*lg).print();
	system("pause");
	
	return 0;
}


