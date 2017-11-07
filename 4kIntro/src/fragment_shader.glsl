#version 430

layout(location=0)uniform vec4 fpar[4];
layout(location=0)out vec4 color;
in vec2 B;

vec2 iResolution = vec2(800,600);
vec4 mins,maxs;
vec2 kColor;
float h(vec2 x,vec2 m,vec2 y){
vec2 v=x-m,l=y-m;
return length(v-l*clamp(dot(v,l)/dot(l,l),0.,1.));
}
float x(vec2 v,float x,float l){
return length(vec2(abs(length(vec2(v.x,max(0.,-(.4-l)-v.y)))-x),max(0.,v.y-.4)));
}
float h(vec2 v){return length(vec2(v.x,max(0.,abs(v.y)-.4)));}
float x(vec2 v){return v.y-=.2,length(vec2(v.x,max(0.,abs(v.y)-.6)));}
float s(vec2 v){return abs(length(vec2(v.x,max(0.,abs(v.y)-.15)))-.25);}
float v(vec2 v){
v=-v;
float x=abs(length(vec2(max(0.,abs(v.x)-.05),v.y-.2))-.2);
x=min(x,length(vec2(v.x+.25,max(0.,abs(v.y-.2)-.2))));
return min(x,(v.x<0.?v.y<0.:atan(v.x,v.y+.15)>2.)?s(v):length(vec2(v.x-.22734,v.y+.254)));
}
float n(vec2 v){
float x=s(v);
return min(v.x<0.||v.y>.05||atan(v.x,v.y+.15)>2.?x:length(vec2(v.x-.22734,v.y+.254)),length(vec2(max(0.,abs(v.x)-.25),v.y-.05)));
}
float l(vec2 v){
return min(h(v),length(vec2(v.x,v.y-.7)));
}
float m(vec2 v){
float l=h(v,vec2(-.25,-.1),vec2(.25,.4));
l=min(l,h(v,vec2(-.15,0.),vec2(.25,-.4)));
v.x+=.25;
return min(l,x(v));
}
float y(vec2 v){
v.y*=-1.;
float l=x(v,.25,.25);
v.x+=.25;
return min(l,h(v));}
void dt(float a,vec2 c, inout vec4 f){
if(a>14.6&&a<16.1){
float s=smoothstep(0.,1.,smoothstep(15.6,16.1,a));
c-=.5*iResolution.xy;
c+=(.5+mix(vec2(-.1,.4),vec2(.2,.3),s))*iResolution.xy;
c=(c-.5*iResolution.xy)/iResolution.x*22.*mix(1.,.5,s);
float h=floor(c.x),i=1.,e=0.;
c.x=mod(c.x,1.)-.5;
if (i++==h)e=min(e,m(c));
if (i++==h)e=min(e,x(c));
if (i++==h)e=min(e,n(c));
if (i++==h)e=min(e,l(c));
if (i++==h)e=min(e,y(c));
if (i++==h)e=min(e,l(c));
if (i++==h)e=min(e,v(c));
if (i++==h)e=min(e,y(c));
float t=17./iResolution.x,o=smoothstep(.06-t,.06+t,i);
f=mix(f,mix(vec4(0),f,o),smoothstep(14.6,15.,a)*(1.-s));
}
}
float[] 
camx = float[](.2351,1.2351,1.2351,1.,.2,.41,.5,.084,.145,3.04,.12,.44,.44,.416,-1.404,.21,.2351,.2351),
camy = float[](-.094,.35,.28,.38,.04,.11,.35,.0614,.418,1.,-.96,.67,.8,.0,-1.,-.06,-.094),
camz = float[](.608,.608,.35,.3608,-.03,.48,.47,0.201,.05,.28,.3,1.445,1.,1.4,2.019,.508,.608),
lookx = float[](-.73,-.627,-1.,-.3,-1.,-.72,-.67,-.5,-.07,-.67,-.27,-.35,-.35,-.775,.08,-.727),
looky = float[](-.364,-.2,-.2,-.2,0.,-.39,-.56,-.37,-.96,-.74,-.94,-.35,-.35,-.1,.83,-.364),
lookz = float[](-.582,-.582,-.5,-.35,-.0,-.58,-.48,-.79,-.25,.06,-.18,-.87,-.87,.23,.55,-.582),
minsx = float[](-.3252,-.3252,-.3252,-.3252,-.3252,-.3252,-1.05,-1.05,-1.21,-1.22,-1.04,-0.737,-.62,-10.,-.653,-.653,-.3252),
minsy = float[](-.7862,-.7862,-.7862,-.7862,-.7862,-.7862,-1.05,-1.05,-.954,-1.17,-.79,-0.73,-.71,-.75,-2.,-2.,-.7862),
minsz = float[](-.0948,-.0948,-.0948,-.0948,-.0948,-.0948,-0.0001,-0.0001,-.0001,-.032,-.126,-1.23,-.85,-.787,-.822,-1.073,-.0948),
minsw = float[](.69,.69,.69,.69,.69,.678,.7,.73,1.684,1.49,.833,.627,.77,.826,1.8976,1.8899,.69),
maxsx = float[](.35,.3457,.3457,.3457,.3457,.3457,1.05,1.05,.39,.85,.3457,.73,.72,5.,.888,.735,.35),
maxsy = float[](1.,1.0218,1.0218,1.0218,1.0218,1.0218,1.05,1.05,.65,.65,1.0218,0.73,.74,1.67,.1665,1.),
maxsz = float[](1.22,1.2215,1.2215,1.2215,1.2215,1.2215,1.27,1.4,1.27,1.27,1.2215,.73,.74,.775,1.2676,1.22),
maxsw = float[](.84,.84,.84,.84,.84,.9834,.95,.93,2.74,1.23,.9834,.8335,.14,1.172,.7798,.84);
float p(vec3 v){
float f,x=1.;
for(int r=0;r<2;r++)
v=2.*clamp(v,mins.xyz,maxs.xyz)-v,
f=max(mins.w/dot(v,v),1.),
v*=f,
x*=f;
float l=length(v.xy);
return.7*max(l-maxs.w,l*v.z/length(v))/x;
}
float t(vec3 x){
float f,y,l=1.;
for(int r=0;r<7;r++)
x=2.*clamp(x,mins.xyz,maxs.xyz)-x,
y=dot(x,x),
l=min(l,y),
f=max(mins.w/y,1.),
x*=f;
return kColor.x+kColor.y*sqrt(l);
}
float p(vec3 v,vec3 x,float f,float m,float y){
float c,r=m;
for(int l=0;l<32;l++){
c=p(v+x*r);if(c<f*r||r>y)return r;r+=c;
}
return-1.;
}
vec2 p(vec3 v,vec3 x){
float c=p(v,x,.0005,.01,5.);return c>0.?vec2(c,t(v+x*c)):vec2(-1.,1.);
}
float t(vec3 v,vec3 c){
float m=p(v,c,.0015,.005,.5);return m>0.?smoothstep(0.,.5,m):1.;
}
float x(vec3 v,vec3 c){
float x,m=0.,y=1.;for(int r=0;r<5;r++)x=.00025+.08*float(r)/4.,m+=-(p(c*x+v)-x)*y,y*=.95;
return clamp(1.-3.*m,0.,1.);
}
vec3 e(vec3 v,float x){
vec3 c=.0005*x*.57*vec3(1,-1,0);
return normalize(c.xyy*p(v+c.xyy)+c.yyx*p(v+c.yyx)+c.yxy*p(v+c.yxy)+c.xxx*p(v+c.xxx));
}
vec3 rd(vec3 v,vec3 x,vec3 c,vec3 f,vec2 m,vec2 y){
vec3 r=normalize(vec3((2.*m.x-1.)*y.x/y.y,2.*m.y-1.,3.));
return normalize(r.x*f+r.y*c+r.z*x);
}
vec4 f(vec3 v,vec3 c){
vec3 r=vec3(.08,.16,.34);vec2 m=p(v,c);float y=m.x;
if(y>0.){
vec3 f=v+y*c,l=e(f,y),
i=reflect(c,l),
n=normalize(vec3(.2,.7,1.6));
r=.5+.5*cos(6.2831*m.y+vec3(0,1,2));
float s=x(f,l),z=.2+.8*t(f,n),g=.3,
B=clamp(dot(l,n),0.,1.),
o=clamp(dot(l,normalize(vec3(-n.x,0.,-n.z))),0.,1.)*clamp(1.-f.y,0.,1.),
a=smoothstep(-.1,.1,i.y),d=clamp(1.+dot(l,c),0.,1.);
d*=d;
float u=pow(clamp(dot(i,n),0.,1.),99.);
vec3 h=vec3(.3)+1.3*z*B*vec3(1.,.8,.55)+2.*u*vec3(1.,.9,.7)*B+.5*s*(.4*g*vec3(.4,.6,1.)+.5*z*vec3(.4,.6,1.)+.25*d);
r = 1.3*r*h;
float w=1./(1.+y*.2+y*.1);
r=mix(w*r*r*s,vec3(.08,.16,.34),smoothstep(0.,.95,y/5.));
}
return vec4(sqrt(r),y);
}
void main() {
float v=.1*fpar[0].x,c=smoothstep(0.,1.,fract(v));
vec2 d=iResolution.xy;
int r=int(v)%18,m=r+1;
vec3 x=mix(vec3(camx[r],camy[r],camz[r]),vec3(camx[m],camy[m],camz[m]),c),
l=mix(vec3(lookx[r],looky[r],lookz[r]),vec3(lookx[m],looky[m],lookz[m]),c),
y=-normalize(cross(l,vec3(0,1,0))),
n=-normalize(cross(y,l));
mins=mix(vec4(minsx[r],minsy[r],minsz[r],minsw[r]),
vec4(minsx[m],minsy[m],minsz[m],minsw[m]),c);
maxs=mix(vec4(maxsx[r],maxsy[r],maxsz[r],maxsw[r]),
vec4(maxsx[m],maxsy[m],maxsz[m],maxsw[m]),c);
kColor=mix(vec2(.25,1.),vec2(.01325,1.23),0.);
vec3 g=rd(x,l,y,n,B,d);
vec4 p=f(x,g);
p.xyz*=pow(16.*B.x*B.y*(1.-B.x)*(1.-B.y),.3);
//dt(mod(v,float(18)),fragCoord.xy,p);
color=p;
}