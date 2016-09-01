//  Created by Evan Bacon on 8/30/16.
//  Copyright (c) 2016 Brix. All rights reserved.


vec3 lDir = normalize(vec3(0.1,1.0,1.0));
float dotProduct = dot(_surface.normal,lDir);

_lightingContribution.diffuse += (dotProduct * dotProduct * _light.intensity.rgb);
_lightingContribution.diffuse = floor(_lightingContribution.diffuse * 4.0) / 3.0;

vec3 halfVector = normalize(lDir + _surface.view);

dotProduct = max(0.0, pow(max(0.0, dot(_surface.normal, halfVector)), _surface.shininess));
dotProduct = floor(dotProduct * 3.0) / 3.0;

//_lightingContribution.specular += (dotProduct * _light.intensity.rgb);
_lightingContribution.specular = vec3(0,0,0);
