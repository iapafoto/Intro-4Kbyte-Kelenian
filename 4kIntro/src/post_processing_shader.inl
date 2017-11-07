/* File generated with Shader Minifier 1.1.4
 * http://www.ctrl-alt-test.fr
 */
#ifndef POST_PROCESSING_SHADER_INL_
# define POST_PROCESSING_SHADER_INL_

const char *post_processing_shader_glsl =
"#version 430\n"
"layout(location=0)uniform vec4 fpar[4];"
"uniform sampler2D inputTexture;"
"layout(location=0)out vec4 color;"
"in vec2 COORD;"
"vec2 res = vec2(1280,1024);"
"const float cosAngle = cos(radians(.5));"
"const float GA =2.399;"
"const mat2 rot = mat2(cos(GA),sin(GA),-sin(GA),cos(GA));"

"bool inCone(vec3 p, vec3 o, vec3 n, float side) {return side*dot(normalize(o - p), n) >= cosAngle;}"

"vec3 RD(const vec2 q) {return normalize(vec3((2.* q.x - 1.) * res.x/res.y, (2.* q.y - 1.), 3.));}"

"float coc(float t) {return max(t*.04, (2. / res.y) * (1. + t));}"

"vec3 dof(sampler2D tex, vec2 uv, float fdist) {"
"vec4 colMain = texture(tex, uv);"
"const float amount = 1.;"
"float rad = min(.5, 10.*coc(abs(colMain.w - fdist)));"
"float r = 1.;"
"vec3 cn = RD(uv),co = cn*fdist,sum = vec3(0.),bokeh = vec3(1),acc = vec3(0),pixPos;"
"vec2 pixScreen,pixel = 1./res.xy,angle = vec2(0, rad);"
"vec4 pixCol;"
"for (int j=0;j<80;j++) {"
"r += 1./r;"
"angle *= rot;"
"pixScreen = uv + pixel*(r-1.)*angle;"
"pixCol = texture(tex, pixScreen);"
"pixPos = pixCol.w * RD(pixScreen);"
"if (inCone(pixPos, co, cn, sign(fdist - pixCol.w))) {"
"bokeh = pow(pixCol.xyz, vec3(9.)) * amount+.4;"
"acc += pixCol.xyz * bokeh;"
"sum += bokeh;"
"}"
"}"
"if (length(sum) == 0.)return colMain.xyz;"
"return acc.xyz/sum;"
"}"
"float[] deph = float[] ( 1.,.65,.6,.4,.2,.4,.65,.11,.13,1.3,.49,1.2,1.2,.5,.65,.45,1.,1.);"
"void main() {"
"float t = .1*fpar[0].x,"
"kt = smoothstep(0.,1.,fract(t));"
"int i0 = int(t)%16, i1 = i0+1;"
"float fdist = mix(deph[i0], deph[i1], kt);"
"vec2 uv = .5*COORD + .5;"
"color=vec4(dof(inputTexture,uv,fdist),1.);"
"}";


//"vec4(dof(inputTexture,uv,fdist),1.);"

/*
"#version 430\n"
"layout(location=0)uniform vec4 fpar[4];"
"uniform sampler2D inputTexture;"
"in vec2 p;"
"void main()"
"{"
"vec2 v=.5*p+.5;"
"float t = fpar[0].x;"
"gl_FragColor= (.5+.5*cos(t))*texture(inputTexture,v);"
"}";
*/

#endif // POST_PROCESSING_SHADER_INL_
