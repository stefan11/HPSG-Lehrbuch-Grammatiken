psoa(h1,e2,
[
 rel('every_q',h3,
     [  attrval('ARG0',x5),
        attrval('RSTR',h4),
       attrval('BODY',h5)]),
 rel('affe_rel',h6,
     [ attrval('ARG0',x5)]),
 rel('schlafen_rel',h8,
     [ attrval('ARG0',e2),
       attrval('ARG1',x5)])],
 hcons([
 qeq(h1,h3),
 qeq(h4,h6),
 qeq(h1,h8)
 ]))